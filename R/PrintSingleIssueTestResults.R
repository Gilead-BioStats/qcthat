#' @rdname FormatHeader
#' @export
FormatHeader.qcthat_SingleIssueTestResults <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (length(x) && any(lengths(x))) {
    if (is.na(x$Issue)) {
      return(
        glue::glue(GetChrCode("box"), GetChrCode("horizontal"), "<no issue>")
      )
    }
    return(FormatSITRHeader(x, lglUseEmoji = lglUseEmoji))
  }
}

#' Format a non-empty SingleIssueTestResults header
#'
#' @inheritParams printing
#' @returns A formatted string for the SingleIssueTestResults header.
#' @keywords internal
FormatSITRHeader <- function(x, lglUseEmoji = getOption("qcthat.emoji", TRUE)) {
  return(
    glue::glue(
      ChooseStateIndicator(x$StateReason, lglUseEmoji = lglUseEmoji),
      GetChrCode("horizontal"),
      "{x$Type} {x$Issue}: {x$Title}"
    )
  )
}

#' Choose an emoji to indicate issue state
#'
#' @param strStateReason (`length-1 character`) Reason for issue state (e.g.,
#'   `completed`) or `NA` if not applicable.
#' @inherit ChooseEmoji return
#' @keywords internal
ChooseStateIndicator <- function(
  strStateReason,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  switch(
    strStateReason %||% "open",
    "completed" = ChooseEmoji("closed (completed)", lglUseEmoji = lglUseEmoji),
    "not_planned" = ChooseEmoji(
      "closed (won't fix)",
      lglUseEmoji = lglUseEmoji
    ),
    ChooseEmoji("open", lglUseEmoji = lglUseEmoji)
  )
}

#' @rdname FormatBody
#' @export
FormatBody.qcthat_SingleIssueTestResults <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (!length(x) || !any(lengths(x))) {
    return(character(0))
  }
  TestResults <- x$TestResults
  if (
    !length(TestResults) || !NROW(TestResults) || all(is.na(TestResults$Test))
  ) {
    return(
      FinalizeTree("(no tests)")
    )
  }
  TestResults$DispositionIndicator <- dplyr::case_match(
    TestResults$Disposition,
    "pass" ~ ChooseEmoji("passed", lglUseEmoji = lglUseEmoji),
    "fail" ~ ChooseEmoji("failed", lglUseEmoji = lglUseEmoji),
    "skip" ~ ChooseEmoji("skipped", lglUseEmoji = lglUseEmoji),
    .default = "[?]"
  )
  chrFormattedResults <- glue::glue(
    "{TestResults$DispositionIndicator}",
    GetChrCode("horizontal"),
    "{TestResults$Test}"
  )
  FinalizeTree(chrFormattedResults)
}
