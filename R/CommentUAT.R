#' Comment on a PR or issue with a UAT report
#'
#' Add or update a comment on a GitHub pull request (or issue) with a report of
#' issues that require user acceptance, formatted in GitHub markdown. Note: This
#' should only be called *after* the test suite has ran.
#'
#' @inheritParams shared-params
#'
#' @returns Invisibly returns the result of [CommentIssue()].
#' @export
CommentUAT <- function(
  intPRNumber = GuessPRNumber(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ),
  lglUpdate = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CommentIssue(
    intPRNumber,
    strTitle = "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance",
    strBody = FormatUATGH(),
    lglUpdate = lglUpdate,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Format UAT issues in GitHub markdown
#'
#' @returns A string containing the UAT issues formatted in GitHub markdown.
#' @keywords internal
FormatUATGH <- function() {
  dfPendingUAT <- dplyr::filter(
    envQcthat$UATIssues,
    .data$Disposition == "pending"
  )
  if (NROW(dfPendingUAT)) {
    strHeader <- paste(
      "Click through to these issues and follow the instructions to accept them as complete",
      "(or to log additional details about changes that are needed before they can be accepted):"
    )
    strIssues <- glue::glue_collapse(
      glue::glue_data(
        dfPendingUAT,
        "- [ ] [{Description}](https://github.com/{Owner}/{Repo}/issues/{UATIssue})"
      ),
      sep = "\n"
    )
    strFooter <- paste(
      "**After all issues have been closed, you must manually re-run the `qcthat PR-Associated Issues Report` action",
      "(until #114 is implemented).**"
    )
    return(
      paste(
        strHeader,
        strIssues,
        strFooter,
        sep = "\n\n"
      )
    )
  }
  return("No issues are awaiting UAT.")
}
