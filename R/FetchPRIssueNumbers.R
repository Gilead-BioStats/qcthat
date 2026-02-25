#' Fetch all issues associated with a GitHub pull request
#'
#' Find issues associated with a GitHub pull request, whether they were added
#' via keywords, using the pull request sidebar, or using the issue sidebar. See
#' [GitHub Docs: Link a pull request to an
#' issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
#' for details on how issues can become associated with a pull request.
#'
#' @inheritParams shared-params
#'
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @export
#'
#' @examplesIf interactive()
#'
#'   #You must have at least one pull request open in the GitHub repository
#'   #associated with the current git repository for this to return any
#'   #results.
#'
#'   FetchPRIssueNumbers()
FetchPRIssueNumbers <- function(
  intPRNumber = GuessPRNumber(strPkgRoot, strOwner, strRepo, strGHToken),
  intPageMax = 100L,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  chrPRRefs <- FetchPRRefs(
    intPRNumber = intPRNumber,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    envCall = envCall
  )
  FetchMergeIssueNumbers(
    strSourceRef = chrPRRefs[["strSourceRef"]],
    strTargetRef = chrPRRefs[["strTargetRef"]],
    intPageMax = intPageMax,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Fetch the source and target refs for a PR
#'
#' @inheritParams shared-params
#' @returns A named character vector with `strSourceRef` and `strTargetRef`.
#' @keywords internal
FetchPRRefs <- function(
  intPRNumber = GuessPRNumber(strPkgRoot, strOwner, strRepo, strGHToken),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  lPR <- FetchRawRepoPRSingle(
    intPRNumber = intPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    envCall = envCall
  )

  if (
    (isTRUE(lPR[["merged"]]) || length(lPR[["merged_at"]])) &&
      length(lPR[["merge_commit_sha"]])
  ) {
    strMergeSHA <- lPR$merge_commit_sha
    lInfo <- GetGitCommitInfo(strMergeSHA, strPkgRoot)
    return(c(
      strSourceRef = strMergeSHA,
      strTargetRef = lInfo$parents[[1]]
    ))
  }
  return(c(
    strSourceRef = lPR$head$ref,
    strTargetRef = lPR$base$ref
  ))
}

#' Fetch a single repo PR from GitHub
#'
#' @inheritParams shared-params
#' @returns A list representing a raw pull request object as returned by
#'   [gh::gh()].
#' @keywords internal
FetchRawRepoPRSingle <- function(
  intPRNumber = GuessPRNumber(".", strOwner, strRepo, strGHToken),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  # nocov start
  tryCatch(
    CallGHAPI(
      "GET /repos/{owner}/{repo}/pulls/{pull_number}",
      strOwner = strOwner,
      strRepo = strRepo,
      pull_number = intPRNumber,
      strGHToken = strGHToken
    ),
    error = function(e) {
      qcthatAbort(
        c(
          "{.arg intPRNumber} must refer to a pull request in the specified repository.",
          i = "Pull request number {.val {intPRNumber}} not found in repository {.val {strOwner}/{strRepo}}."
        ),
        strErrorSubclass = "pr_not_found",
        envCall = envCall
      )
    }
  )
  # nocov end
}

#' Wrapper around gert::git_commit_info() for mocking
#'
#' @param strRef (`length-1 character`) A branch, tag, or commit SHA.
#' @inheritParams shared-params
#' @returns The result of [gert::git_commit_info()].
#' @keywords internal
GetGitCommitInfo <- function(strRef, strPkgRoot = ".") {
  # nocov start
  gert::git_commit_info(ref = strRef, repo = strPkgRoot)
  # nocov end
}
