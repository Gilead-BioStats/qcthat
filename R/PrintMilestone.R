#' @rdname FormatHeader
#' @export
FormatHeader.qcthat_Milestone <- function(x, ...) {
  if (length(x) && any(lengths(x))) {
    strMilestone <- dplyr::coalesce(x$Milestone, "<none>")
    intIssues <- CountNonNA(x$IssueTestResults$Issue)
    intTests <- CountNonNA(
      purrr::list_rbind(x$IssueTestResults$TestResults)$Test
    )
    strIssue <- SimplePluralize("issue", intIssues)
    strTest <- SimplePluralize("test", intTests)
    return(glue::glue(
      GetChrCode("box"),
      GetChrCode("horizontal"),
      "Milestone: {strMilestone} ({intIssues} {strIssue}, {intTests} {strTest})"
    ))
  }
}

#' @rdname FormatBody
#' @export
FormatBody.qcthat_Milestone <- function(x, ...) {
  if (!length(x) || !any(lengths(x))) {
    return(character(0))
  }
  lFormattedIssues <- purrr::map(
    AsRowDFList(x$IssueTestResults, AsSingleIssueTestResults),
    function(x) {
      format(x, ...)
    }
  )
  FinalizeTree(lFormattedIssues)
}

#' Listify a 1-row data frame and assign the qcthat_SingleIssueTestResults class
#'
#' @inheritParams AsExpectedFlat
#' @returns A `qcthat_Milestone` object, which is a list with elements
#'   `"Milestone"` and `"IssueTestResults"`.
#' @keywords internal
AsSingleIssueTestResults <- function(x) {
  AsExpectedFlat(
    x,
    lShape = list(
      Issue = integer(0),
      Title = character(0),
      State = character(0),
      StateReason = character(0),
      Type = character(0),
      TestResults = tibble::tibble()
    ),
    chrClass = "qcthat_SingleIssueTestResults"
  )
}
