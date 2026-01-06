#' Comment on a PR or issue with a QC report
#'
#' Add or update a comment on a GitHub pull request (or issue) with a QC report,
#' formatted in GitHub markdown.
#'
#' @inheritParams shared-params
#'
#' @returns Invisibly returns the result of [CommentIssue()].
#' @export
CommentReport <- function(
  dfITM,
  strReportType,
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
    strTitle = paste(
      "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report:",
      strReportType
    ),
    strBody = FormatReportGH(dfITM),
    lglUpdate = lglUpdate,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Format a QC report in GitHub markdown
#'
#' @inheritParams shared-params
#' @returns A character string containing the report formatted in GitHub
#'   markdown.
#' @keywords internal
FormatReportGH <- function(dfITM) {
  lOptions <- options(pillar.subtle = FALSE)
  on.exit(options(lOptions), add = TRUE)
  chrHeader <- FormatHeader(dfITM)
  chrBody <- c(FormatBody(dfITM), FormatKey())

  # I know I had a reason to add this but I can't currently find the situation
  # that triggers it.
  #
  # nocov start
  if (length(chrHeader) > 1) {
    chrBody <- c(chrHeader[-1], chrBody)
    chrHeader <- chrHeader[1]
  }
  # nocov end

  chrFooter <- FormatFooterMain(dfITM)
  chrFooter <- chrFooter[nzchar(chrFooter)]

  glue::glue(
    "<details>",
    "<summary>{chrHeader}</summary>",
    "",
    "```",
    paste(chrBody, collapse = "\n"),
    "```",
    "</details>",
    paste(chrFooter, collapse = "\n\n"),
    .sep = "\n"
  )
}
