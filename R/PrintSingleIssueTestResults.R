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
#' @inheritParams printing
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
  TestResults$DispositionIndicator <- ChooseDispositionIndicator(
    TestResults$Disposition,
    lglUseEmoji = lglUseEmoji
  )
  chrFormattedResults <- glue::glue(
    "{TestResults$DispositionIndicator}",
    GetChrCode("horizontal"),
    "{TestResults$Test}"
  )
  FinalizeTree(chrFormattedResults)
}

#' Choose emoji to indicate test disposition
#'
#' @param chrDisposition (`character`) Test disposition. Generally one of
#'   `"pass"`, `"fail"`, or `"skip"`.
#' @inheritParams printing
#' @returns A character vector of the same length as `chrDisposition`, with each
#'   element being the emoji or ASCII indicator for the corresponding test
#'   disposition.
#' @keywords internal
ChooseDispositionIndicator <- function(
  chrDisposition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  dplyr::case_match(
    chrDisposition,
    "pass" ~ ChooseEmoji("passed", lglUseEmoji = lglUseEmoji),
    "fail" ~ ChooseEmoji("failed", lglUseEmoji = lglUseEmoji),
    "skip" ~ ChooseEmoji("skipped", lglUseEmoji = lglUseEmoji),
    .default = "[?]"
  )
}
