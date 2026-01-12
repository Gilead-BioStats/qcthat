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
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  dfRepoIssues <- FetchRepoIssues(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  strPkgRoot <- GetPkgRoot(strPkgRoot, envCall = envCall)
  strTestthatParallel <- Sys.getenv("TESTTHAT_PARALLEL")
  on.exit(
    Sys.setenv(TESTTHAT_PARALLEL = strTestthatParallel),
    add = TRUE
  )
  Sys.setenv(TESTTHAT_PARALLEL = "FALSE")

  dfTestResults <- CompileTestResults(
    testthat::test_local(
      strPkgRoot,
      stop_on_failure = FALSE,
      reporter = "silent"
    )
  )
  return(
    CompileIssueTestMatrix(
      dfRepoIssues,
      dfTestResults,
      chrIgnoredLabels = chrIgnoredLabels
    )
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
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels()
) {
  dfIssueTestMatrix <- QCPackage(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    chrIgnoredLabels = chrIgnoredLabels
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
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  dfITM <- QCPackage(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    chrIgnoredLabels = chrIgnoredLabels,
    envCall = envCall
  )
  intMissingIssues <- intIssues[!intIssues %in% dfITM$Issue]
  if (length(intMissingIssues)) {
    lIgnoredIssues <- attr(dfITM, "IgnoredIssues")
    intIgnoredIssues <- CompletelyFlatten(lIgnoredIssues[chrIgnoredLabels])
    intMissingIssues <- setdiff(intMissingIssues, intIgnoredIssues)

    if (length(intMissingIssues) == length(intIssues)) {
      qcthatAbort(
        c(
          "{.arg intIssues} must refer to at least one issue in the issue-test matrix.",
          i = "Unknown issues: {intMissingIssues}"
        ),
        strErrorSubclass = "unknown_issues",
        envCall = envCall
      )
    }
    if (length(intMissingIssues) && lglWarn) {
      cli::cli_warn(
        c(
          "Some {.arg intIssues} are not in the issue-test matrix.",
          i = "Unknown issues: {intMissingIssues}"
        ),
        class = CompileConditionClasses("unknown_issues", "warning"),
        env = envCall
      )
    }
  }
  dplyr::filter(dfITM, !is.na(.data$Issue), .data$Issue %in% intIssues)
}

#' Generate a QC report of a specific milestone or milestones
#'
#' Generate a report about the test status of issues in a milestone or
#' milestones.
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
#'   # a milestone named "v0.1.0" on GitHub.
#'   QCMilestones("v0.1.0")
QCMilestones <- function(
  chrMilestones,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  dfITM <- QCPackage(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    chrIgnoredLabels = chrIgnoredLabels,
    envCall = envCall
  )
  chrMissingMilestones <- chrMilestones[!chrMilestones %in% dfITM$Milestone]
  if (length(chrMissingMilestones)) {
    if (length(chrMissingMilestones) == length(chrMilestones)) {
      qcthatAbort(
        c(
          "{.arg chrMilestones} must refer to at least one milestone in the issue-test matrix.",
          i = "Unknown milestones: {chrMissingMilestones}"
        ),
        strErrorSubclass = "unknown_milestones",
        envCall = envCall
      )
    }
    if (lglWarn) {
      cli::cli_warn(
        c(
          "Some {.arg chrMilestones} are not in the issue-test matrix.",
          i = "Unknown milestones: {chrMissingMilestones}"
        ),
        class = CompileConditionClasses("unknown_milestones", "warning"),
        envCall = envCall
      )
    }
  }
  dplyr::filter(
    dfITM,
    !is.na(.data$Milestone),
    .data$Milestone %in% chrMilestones,
    # Remove issues that are marked "duplicate" or "won't fix".
    is.na(.data$StateReason) | .data$StateReason == "completed"
  )
}
