#' Generate a QC report for a package
#'
#' A QC report combines information about GitHub issues associated with a
#' package (see [FetchRepoIssues()]) and testthat test results for the package
#' (see [CompileTestResults()]) using [CompileIssueTestMatrix()].
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by
#'   [CompileIssueTestMatrix()].
#' @export
#'
#' @examplesIf interactive()
#'
#'   QCPackage()
QCPackage <- function(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  dfRepoIssues <- FetchRepoIssues(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  strPkgRoot <- GetPkgRoot(strPkgRoot, envCall = envCall)
  dfTestResults <- CompileTestResults(
    testthat::test_local(
      strPkgRoot,
      stop_on_failure = FALSE,
      reporter = "silent"
    )
  )
  return(
    CompileIssueTestMatrix(dfRepoIssues, dfTestResults)
  )
}

#' Generate a QC report of completed issues
#'
#' A simple wrapper around [QCPackage()] that filters the resulting issue-test
#' matrix to only include issues that were closed as "completed".
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that were closed as completed.
#'
#' @export
#'
#' @examplesIf interactive()
#'
#'   QCCompletedIssues()
QCCompletedIssues <- function(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token()
) {
  dfIssueTestMatrix <- QCPackage(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  return(
    dplyr::filter(
      dfIssueTestMatrix,
      !is.na(.data$StateReason) & .data$StateReason == "completed"
    )
  )
}

#' Generate a QC report of issues associated with a branch or other Git ref
#'
#' Find issues associated with merging a source ref into a target ref and
#' generate a report about their test status.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that will be closed by merging `strSourceRef` into
#'   `strTargetRef`, using the [GitHub keywords for linking issues to pull
#'   requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword).
#'
#' @export
#'
#' @examplesIf interactive()
#'
#'   # This will only make sense if you are working in a git repository and have
#'   # an active branch that is different from the default branch.
#'   QCBranch()
QCBranch <- function(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  chrKeywords = c(
    "close",
    "closes",
    "closed",
    "fix",
    "fixes",
    "fixed",
    "resolve",
    "resolves",
    "resolved"
  ),
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  intMaxCommits = 100000L
) {
  intAssociatedIssues <- FindKeywordIssues(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
    strPkgRoot = strPkgRoot,
    chrKeywords = chrKeywords,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    intMaxCommits = intMaxCommits
  )
  QCIssues(
    intAssociatedIssues,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Generate a QC report of specific issues
#'
#' Generate a report about the test status of specific issues.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to the indicated issues.
#'
#' @export
#'
#' @examplesIf interactive()
#'
#'   # This will only make sense if you are working in a git repository that has
#'   # issues #84 and #85 on GitHub.
#'   QCIssues(c(84, 85))
QCIssues <- function(
  intIssues,
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  dfITM <- QCPackage(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    envCall = envCall
  )
  intMissingIssues <- intIssues[!intIssues %in% dfITM$Issue]
  if (length(intMissingIssues)) {
    cli::cli_warn(
      c(
        "Some {.arg intIssues} are not in the issue-test matrix.",
        i = "Unknown issues: {intMissingIssues}"
      ),
      class = "qcthat-warning-unknown_issues"
    )
  }
  dplyr::filter(dfITM, !is.na(.data$Issue), .data$Issue %in% intIssues)
}

#' Generate a QC report of issues associated with a GitHub pull request
#'
#' Find issues associated with a GitHub pull request, whether they were added
#' via keywords, using the pull request sidebar, or using the issue sidebar. See
#' [GitHub Docs: Link a pull request to an
#' issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
#' for details on how issues can become associated with a pull request.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that will be closed by merging the pull request.
#'
#' @export
#'
#' @examplesIf interactive()
#'
#'   # You must have at least one pull request open in the GitHub repository
#'   # associated with the current git repository for this to return any
#'   # results.
#'   QCPR()
QCPR <- function(
  intPRNumber = FetchLatestRepoPRNumber(strOwner, strRepo, strGHToken, "open"),
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  intMaxCommits = 100000L
) {
  # Technically we look at the refs (what's merging into what) on GitHub, and
  # then find all issues associated with any PRs that differentiate those refs
  # from one another.
  #
  # 1. Get the strSourceRef (HeadRef) and strTargetRef (BaseRef) for intPRNumber
  #
  dfPR <- FetchRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = "all"
  ) |>
    dplyr::filter(.data$PR == intPRNumber)
  if (!NROW(dfPR)) {
    cli::cli_abort(
      c(
        "{.arg intPRNumber} must refer to a pull request in the specified repository.",
        i = "Pull request number {.val {intPRNumber}} not found in repository {.val {strOwner}/{strRepo}}."
      ),
      class = "qcthat-error-pr_not_found"
    )
  }
  strSourceRef <- dfPR$HeadRef[[1]]
  strTargetRef <- dfPR$BaseRef[[1]]
  compare <- gh::gh(
    "GET /repos/{owner}/{repo}/compare/{target}...{source}",
    owner = strOwner,
    repo = strRepo,
    target = strTargetRef,
    source = strSourceRef,
    .limit = Inf
  )
  commit_shas <- purrr::map_chr(compare$commits, "sha")
  commit_pr_query_template <- '
  c<alias>: object(oid: "<sha>") {
    ... on Commit {
      # Get the PR(s) associated with this commit
      associatedPullRequests(first: 100) {
        nodes {
          number
        }
      }
    }
  }
'
  aliases <- paste0("i_", seq_along(commit_shas))
  all_commit_pr_queries <- purrr::map2_chr(
    commit_shas,
    aliases,
    ~ glue::glue(
      commit_pr_query_template,
      sha = .x,
      alias = .y
    )
  ) |>
    paste(collapse = "\n")

  final_pr_query <- glue::glue(
    '
  query {{
    repository(owner: "{strOwner}", name: "{strRepo}") {{
      {all_commit_pr_queries}
    }}
  }}
  '
  )

  pr_response <- gh::gh_gql(query = final_pr_query)
  pr_numbers <- pr_response$data$repository |>
    # Get all commit objects
    purrr::map("associatedPullRequests") |>
    purrr::map("nodes") |>
    purrr::list_flatten() |>
    # Get the PR numbers
    purrr::map_int("number") |>
    unique() |>
    sort()
}
