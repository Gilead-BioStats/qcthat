#' @rdname FormatHeader
#' @export
FormatHeader.qcthat_IssueTestMatrix <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  lglShowMilestones = TRUE
) {
  intIssues <- CountNonNA(x$Issue)
  intTests <- CountNonNA(x$Test)
  strIssue <- SimplePluralize("issue", intIssues)
  strTest <- SimplePluralize("test", intTests)
  if (lglShowMilestones) {
    intMilestones <- CountNonNA(x$Milestone)
    strMilestone <- SimplePluralize("milestone", intMilestones)
    strSummary <- glue::glue(
      "{intMilestones} {strMilestone},",
      "{intIssues} {strIssue},",
      "and {intTests} {strTest}",
      .sep = " "
    )
  } else {
    strSummary <- glue::glue(
      "{intIssues} {strIssue} and {intTests} {strTest}"
    )
  }

  glue::glue(
    ChooseOverallDispositionIndicator(x$Disposition, lglUseEmoji = lglUseEmoji),
    "A qcthat issue test matrix with {strSummary}",
    .sep = " "
  )
}

#' @rdname FormatFooter
#' @export
FormatFooter.qcthat_IssueTestMatrix <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (NROW(x)) {
    c(
      pillar::style_subtle(c(
        glue::glue(
          "# Issue state:",
          glue::glue(
            MakeKeyItem("open", lglUseEmoji = lglUseEmoji),
            MakeKeyItem("closed (completed)", lglUseEmoji = lglUseEmoji),
            MakeKeyItem("closed (won't fix)", lglUseEmoji = lglUseEmoji),
            .sep = ", "
          ),
          .sep = " "
        ),
        glue::glue(
          "# Test disposition:",
          glue::glue(
            MakeKeyItem("passed", lglUseEmoji = lglUseEmoji),
            MakeKeyItem("failed", lglUseEmoji = lglUseEmoji),
            MakeKeyItem("skipped", lglUseEmoji = lglUseEmoji),
            .sep = ", "
          ),
          .sep = " "
        )
      )),
      MakeITRDispositionFooter(x$Disposition, lglUseEmoji = lglUseEmoji),
      MakeITRCoverageFooter(x$Issue, x$Test, lglUseEmoji = lglUseEmoji)
    )
  }
}

#' Add a summary message to ITR footer
#'
#' @inheritParams shared-params
#' @returns A string summary message or `NULL` if no disposition is available.
#' @keywords internal
MakeITRDispositionFooter <- function(
  fctDisposition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (!length(fctDisposition) || all(is.na(fctDisposition))) {
    return(NULL)
  }
  strOverallDispositionIndicator <- ChooseOverallDispositionIndicator(
    fctDisposition,
    lglUseEmoji = lglUseEmoji
  )
  strMessage <- ChooseOverallDispositionMessage(fctDisposition)
  if (length(strMessage)) {
    c("", glue::glue("{strOverallDispositionIndicator} {strMessage}"))
  }
}

#' Choose overall disposition message
#'
#' @inheritParams shared-params
#' @returns A string summary message or `NULL` if no disposition is available.
#' @keywords internal
ChooseOverallDispositionMessage <- function(fctDisposition) {
  if (!length(fctDisposition) || all(is.na(fctDisposition))) {
    return(NULL)
  }
  switch(
    as.character(sort(fctDisposition)[[1]]),
    "pass" = "All tests passed",
    "fail" = "At least one test failed",
    "skip" = "At least one test was skipped",
    "Tests have unknown disposition"
  )
}

#' Choose overall disposition indicator
#'
#' @inheritParams shared-params
#' @returns An emoji or other string indicating the overall disposition of all
#'   tests.
#' @keywords internal
ChooseOverallDispositionIndicator <- function(
  fctDisposition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (length(fctDisposition) && !all(is.na(fctDisposition))) {
    return(
      ChooseDispositionIndicator(sort(fctDisposition)[[1]])
    )
  }
  return(GetChrCode("box"))
}

#' Add a coverage summary message to ITR footer
#'
#' @inheritParams shared-params
#' @returns One or two string summary messages or `NULL` if neither message
#'   applies.
#' @keywords internal
MakeITRCoverageFooter <- function(
  intIssues,
  chrTests,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  c(
    ChooseCoverageFooter(intIssues, chrTests, lglUseEmoji = lglUseEmoji),
    ChooseOrphanFooter(intIssues, chrTests, lglUseEmoji = lglUseEmoji)
  )
}

#' Choose coverage footer
#'
#' @inheritParams shared-params
#' @returns A string with or without an emoji describing test coverage of
#'   issues, or `NULL` if there aren't any issues.
#' @keywords internal
ChooseCoverageFooter <- function(
  intIssues,
  chrTests,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (any(!is.na(intIssues))) {
    if (any(!is.na(intIssues) & is.na(chrTests))) {
      strCoverageIndicator <- ChooseEmoji("uncovered", lglUseEmoji)
      strCoverageMessage <- "At least one issue lacks tests"
    } else {
      strCoverageIndicator <- ChooseEmoji("covered", lglUseEmoji)
      strCoverageMessage <- "All issues have at least one test"
    }
    glue::glue("{strCoverageIndicator} {strCoverageMessage}")
  }
}

#' Choose orphan footer
#'
#' @inheritParams shared-params
#' @returns A string with or without an emoji describing test linkage to issues,
#'   or `NULL` if there aren't any tests.
#' @keywords internal
ChooseOrphanFooter <- function(
  intIssues,
  chrTests,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  if (any(!is.na(chrTests) & is.na(intIssues))) {
    strOrphanedIndicator <- ChooseEmoji("orphaned", lglUseEmoji)
    strOrphanedMessage <- "At least one test is not linked to any issue"
    glue::glue("{strOrphanedIndicator} {strOrphanedMessage}")
  }
}

#' @rdname FormatBody
#' @export
FormatBody.qcthat_IssueTestMatrix <- function(
  x,
  ...,
  lglShowMilestones = TRUE
) {
  if (NROW(x)) {
    if (!lglShowMilestones) {
      x$Milestone <- NA
      x <- AsNestedIssueTestMatrix(x)
      lFormattedIssues <- purrr::map(
        AsRowDFList(x$IssueTestResults[[1]], AsSingleIssueTestResults),
        function(x) {
          format(x, ...)
        }
      )
      return(FinalizeTree(lFormattedIssues))
    }
    x <- AsNestedIssueTestMatrix(x)
    lFormattedMilestones <- purrr::map(
      AsRowDFList(x, AsMilestone),
      function(x) {
        format(x, ...)
      }
    )
    FinalizeTree(lFormattedMilestones)
  }
}

#' Nest a qcthat_IssueTestMatrix by Milestone and Issue
#'
#' @inheritParams printing
#' @returns A tibble with `TestResults` nested by `Issue`, and
#'   `IssueTestResults` nested by `Milestone`.
#' @keywords internal
AsNestedIssueTestMatrix <- function(x) {
  # Remove the special class so no sub-pieces inherit it.
  class(x) <- class(tibble::tibble())
  x |>
    dplyr::select(
      "Milestone",
      "Issue",
      "Title",
      "State",
      "StateReason",
      "Type",
      "Test",
      "File",
      "Disposition"
    ) |>
    tidyr::nest(
      TestResults = c("Test", "File", "Disposition")
    ) |>
    tidyr::nest(.by = "Milestone", .key = "IssueTestResults")
}

#' Listify a 1-row data frame and assign the qcthat_Milestone class
#'
#' @inheritParams AsExpectedFlat
#' @returns A `qcthat_Milestone` object, which is a list with elements
#'   `"Milestone"` and `"IssueTestResults"`.
#' @keywords internal
AsMilestone <- function(x) {
  AsExpectedFlat(
    x,
    lShape = list(
      Milestone = character(0),
      IssueTestResults = tibble::tibble()
    ),
    chrClass = "qcthat_Milestone"
  )
}
