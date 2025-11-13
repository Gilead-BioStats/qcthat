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
