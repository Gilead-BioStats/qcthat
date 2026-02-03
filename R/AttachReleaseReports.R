#' Attach QC reports to a GitHub release
#'
#' Update a GitHub release with one or more QC reports, formatted in GitHub
#' markdown.
#'
#' @inheritParams shared-params
#'
#' @returns `dfITM`, invisibly.
#' @export
AttachReleaseReports <- function(
  strReleaseID = GuessReleaseID(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ),
  lglCompleted = TRUE,
  lglMilestone = length(chrMilestones),
  chrMilestones = GuessMilestones(),
  dfITM = NULL,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strPkgRoot = ".",
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  if (length(strReleaseID) && (lglCompleted || lglMilestone)) {
    dfITM <- dfITM %||%
      QCPackage(
        strPkgRoot = strPkgRoot,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        chrIgnoredLabels = chrIgnoredLabels,
        envCall = envCall
      )

    chrBody <- character()
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
    if (length(chrBody)) {
      UpdateReleaseBody(
        strReleaseID = strReleaseID,
        strBody = paste(
          "## [{qcthat}](https://gilead-biostats.github.io/qcthat/) Reports",
          chrBody,
          collapse = "\n\n\n",
          sep = "\n\n"
        ),
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    }
  }
  return(invisible(dfITM))
}

#' Update the body of a GitHub release
#'
#' @inheritParams shared-params
#' @returns The updated release object as returned by [gh::gh()].
#' @keywords internal
UpdateReleaseBody <- function(
  strReleaseID,
  strBody,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strExistingBody <- CallGHAPI(
    "GET /repos/{owner}/{repo}/releases/{release_id}",
    release_id = strReleaseID,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )$body

  if (length(strExistingBody)) {
    strBody <- paste(strExistingBody, strBody, sep = "\n\n\n")
  }

  CallGHAPI(
    "PATCH /repos/{owner}/{repo}/releases/{release_id}",
    release_id = strReleaseID,
    body = strBody,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}
