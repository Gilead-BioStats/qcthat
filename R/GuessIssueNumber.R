#' Guess the relevant issue number from the GitHub event
#'
#' Determine the issue number associated with the current GitHub event, if the
#' workflow was triggered by an `"issues"` event.
#'
#' @param lGHEventPayload (`list`) The GitHub event payload. Defaults to the
#'   result of [LoadGHEventPayload()].
#'
#' @returns An integer representing the issue number (if the event payload
#'   contains `issue$number` or `inputs$issueNumber`), or `NULL` if the event is
#'   not an `"issues"` event or the issue number cannot be found.
#' @export
GuessIssueNumber <- function(lGHEventPayload = LoadGHEventPayload()) {
  if (is.list(lGHEventPayload)) {
    intIssueNumber <- lGHEventPayload$issue$number %||%
      lGHEventPayload$inputs$issueNumber
    intIssueNumber <- suppressWarnings(as.integer(intIssueNumber))
    if (length(intIssueNumber) && !is.na(intIssueNumber)) {
      return(intIssueNumber)
    }
  }
}
