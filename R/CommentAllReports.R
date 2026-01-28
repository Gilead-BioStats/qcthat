#' Comment on a PR or issue with a QC report
#'
#' Add or update a comment on a GitHub pull request (or issue) with a QC report,
#' formatted in GitHub markdown.
#'
#' @param lglCompleted (`length-1 logical`) Whether to include the
#'   [QCCompletedIssues()] report.
#' @param lglMilestone (`length-1 logical`) Whether to include the
#'   [QCMilestones()] report.
#' @param lglPR (`length-1 logical`) Whether to include the [QCMilestones()]
#'   report.
#' @param lglUAT (`length-1 logical`) Whether to include the [CommentUAT()]
#'   report.
#' @inheritParams shared-params
#'
#' @returns `dfITM`, invisibly.
#' @export
CommentAllReports <- function(
  intPRNumber = GuessPRNumber(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ),
  lglCompleted = TRUE,
  lglMilestone = length(chrMilestones),
  lglPR = TRUE,
  lglUAT = TRUE,
  chrMilestones = GuessMilestones(),
  dfITM = NULL,
  lglUpdate = TRUE,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  if (any(lglCompleted, lglMilestone, lglPR, lglUAT)) {
    dfITM <- dfITM %||%
      QCPackage(
        strPkgRoot = strPkgRoot,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        chrIgnoredLabels = chrIgnoredLabels,
        envCall = envCall
      )
  }

  chrBody <- character()
  if (lglPR) {
    chrBody <- c(
      chrBody,
      FormatReportType(
        fnReport = QCPR,
        strReportType = "PR-Associated Issues",
        strPkgRoot = strPkgRoot,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        chrIgnoredLabels = chrIgnoredLabels,
        dfITM = dfITM,
        lOtherArgs = list(intPRNumber = intPRNumber, lglWarn = lglWarn),
        envCall = envCall
      )
    )
  }
  if (lglMilestone && length(chrMilestones)) {
    chrBody <- c(
      chrBody,
      FormatReportType(
        fnReport = QCMilestones,
        strReportType = "Milestone",
        strPkgRoot = strPkgRoot,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        chrIgnoredLabels = chrIgnoredLabels,
        dfITM = dfITM,
        lOtherArgs = list(chrMilestones = chrMilestones),
        envCall = envCall
      )
    )
  }
  if (lglCompleted) {
    chrBody <- c(
      chrBody,
      FormatReportType(
        fnReport = QCCompletedIssues,
        strReportType = "Completed Issues",
        strPkgRoot = strPkgRoot,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        chrIgnoredLabels = chrIgnoredLabels,
        dfITM = dfITM,
        envCall = envCall
      )
    )
  }
  if (lglUAT) {
    # chrBody <- c(
    #   chrBody,
    #   FormatReportBody("User Acceptance", FormatUATGH())
    # )
    CommentUAT(
      intPRNumber = intPRNumber,
      lglUpdate = lglUpdate,
      strRunID = strRunID,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
  if (length(chrBody)) {
    CommentIssue(
      intIssue = intPRNumber,
      strTitle = "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Reports",
      strBody = paste(chrBody, collapse = "\n\n\n"),
      lglUpdate = lglUpdate,
      strRunID = strRunID,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }

  return(invisible(dfITM))
}

FormatReportType <- function(
  fnReport,
  strReportType,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels(),
  dfITM = NULL,
  lOtherArgs = list(),
  envCall = rlang::caller_env()
) {
  dfITM <- rlang::inject(fnReport(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    chrIgnoredLabels = chrIgnoredLabels,
    dfITM = dfITM,
    envCall = envCall,
    !!!lOtherArgs
  ))
  FormatReportBody(strReportType, FormatReportGH(dfITM))
}

FormatReportBody <- function(strReportType, strBody) {
  paste(
    paste("###", strReportType),
    strBody,
    "<hr>",
    sep = "\n"
  )
}
