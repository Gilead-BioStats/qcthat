#' Printing Issue-Test Matrices
#'
#' One of the main purposes of qcthat is to produce user-friendly reports about
#' a package's issue and test status. Printing an issue-test matrix provides a
#' nested view of the relationship between milestones, issues, and tests, as
#' well as the state of issues ("open", "closed (completed)", or "closed (won't
#' fix)") and the disposition of tests ("passed", "failed", or "skipped").
#'
#' @param x (`qcthat_IssueTestMatrix`) The issue-test matrix to format.
#' @param transform (`function`) A function to transform the output before
#'   returning it. By default, this is [base::identity()] for `format()`
#'   (returns the formatted output), and [base::writeLines()] for `print()`
#'   (sends the output to [stdout()]).
#' @inheritParams rlang::args_dots_empty
#'
#' @examplesIf interactive()
#'
#'   lTestResults <- testthat::test_local(stop_on_failure = FALSE)
#'   IssueTestMatrix <- CompileIssueTestMatrix(
#'     dfRepoIssues = FetchRepoIssues(),
#'     dfTestResults = CompileTestResults(lTestResults)
#'   )
#'   print(IssueTestMatrix)
#'
#'   # Remove the "qcthat_IssueTestMatrix" class to see the raw tibble.
#'   print(tibble::as_tibble(IssueTestMatrix))
#'
#' @name formatting
NULL

#' @rdname formatting
#' @export
print.qcthat_IssueTestMatrix <- function(x, ...) {
  # The `transform` argument causes the output to be printed to stdout as a side
  # effect rather than returned. This method is borrowed from {pillar}, which is
  # what {tibble} uses for printing/formatting.
  format(x, ..., transform = writeLines)
  invisible(x)
}

#' @rdname formatting
#' @export
format.qcthat_IssueTestMatrix <- function(x, ..., transform = identity) {
  force(x)
  transform(c(
    FormatHeader(x),
    FormatMilestones(x),
    FormatFooter(x)
  ))
}

#' Prepare the top of the qcthat_IssueTestMatrix output
#'
#' @inheritParams formatting
#' @returns A character vector representing the formatted header.
#' @keywords internal
FormatHeader <- function(x) {
  intMilestones <- NROW(x)
  lITR <- x$IssueTestResults %||% list()
  dfITR_all <- purrr::list_rbind(lITR)
  intIssues <- CountNonNA(dfITR_all$Issue)
  lTR <- dfITR_all$TestResults %||% list()
  dfTR_all <- purrr::list_rbind(lTR)
  intTests <- CountNonNA(dfTR_all$Test)
  pillar::style_subtle(
    glue::glue(
      "# A qcthat issue test matrix with",
      "{intMilestones} milestones,",
      "{intIssues} issues,",
      "and {intTests} tests",
      .sep = " "
    )
  )
}

#' Convenience function to count non-NA unique values
#'
#' @param x (`vector`) Vector to count unique non-NA values in.
#' @returns An integer representing the number of unique non-NA values in `x`.
#' @keywords internal
CountNonNA <- function(x) {
  sum(!is.na(unique(x)))
}

#' Prepare the bottom of the qcthat_IssueTestMatrix output
#'
#' @inheritParams formatting
#' @returns If `x` has rows, a character vector representing the formatted
#'   footer. `NULL` otherwise.
#' @keywords internal
FormatFooter <- function(x) {
  if (NROW(x)) {
    pillar::style_subtle(c(
      glue::glue(
        "# Issue state:",
        glue::glue(
          MakeKeyItem("open"),
          MakeKeyItem("closed (completed)"),
          MakeKeyItem("closed (won't fix)"),
          .sep = ", "
        ),
        .sep = " "
      ),
      glue::glue(
        "# Test disposition:",
        glue::glue(
          MakeKeyItem("passed"),
          MakeKeyItem("failed"),
          MakeKeyItem("skipped"),
          .sep = ", "
        ),
        .sep = " "
      )
    ))
  }
}

#' Helper to insert emojis into key items
#'
#' @param lglUseEmoji (`length-1 logical`) Whether to use emojis (if `TRUE`) or
#'   ASCII.
#' @param strCondition (`length-1 character`) The condition to create a key item
#'   for.
#' @returns A length-1 character vector representing the key item with an emoji.
#' @keywords internal
MakeKeyItem <- function(
  strCondition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  glue::glue("{ChooseEmoji(strCondition, lglUseEmoji)} = {strCondition}")
}

#' Helper to choose emojis or ASCII indicators
#'
#' @inheritParams MakeKeyItem
#' @returns A length-1 character vector representing the emoji or ASCII
#'   indicator for the given condition.
#' @keywords internal
ChooseEmoji <- function(
  strCondition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  # nocov start
  if (lglUseEmoji) {
    chrEmoji <- c(
      open = "inbox_tray",
      `closed (completed)` = "check_box_with_check",
      `closed (won't fix)` = "no_entry",
      passed = "white_check_mark",
      failed = "cross_mark",
      skipped = "no_entry_sign"
    )
    emoji::emoji(chrEmoji[[strCondition]])
    # nocov end
  } else {
    chrASCII <- c(
      open = "[o]",
      `closed (completed)` = "[x]",
      `closed (won't fix)` = "[-]",
      passed = "[v]",
      failed = "[!]",
      skipped = "[S]"
    )
    chrASCII[[strCondition]]
  }
}

#' Helper to choose tree characters
#'
#' R CMD check doesn't like these characters appearing "raw", and they're hard
#' to read as U codes, so encode them in one place.
#'
#' @param strCharacterDescription (`length-1 character`) The special character
#'   to choose.
#' @returns A length-1 character vector representing the chosen tree character.
#' @keywords internal
ChooseTreeCharacter <- function(strCharacterDescription) {
  chrTreeCharacters <- c(
    box = "\U2588",
    branch = "\U251C",
    horizontal = "\U2500",
    vertical = "\U2502",
    elbow = "\U2514"
  )
  chrTreeCharacters[[strCharacterDescription]]
}

#' Prepare the main part of the qcthat_IssueTestMatrix output
#'
#' @inheritParams formatting
#' @returns If `x` has rows, a character vector representing the tree that
#'   describes the milestones, issues, and tests in `x`. `NULL` otherwise.
#' @keywords internal
FormatMilestones <- function(x) {
  if (NROW(x)) {
    x$Milestone <- dplyr::coalesce(x$Milestone, "<none>")
    lFormattedMilestones <- purrr::pmap(x, FormatMilestone)
    c(ChooseTreeCharacter("box"), FinalizeTree(lFormattedMilestones))
  }
}

#' Prepare a single milestone of the qcthat_IssueTestMatrix output
#'
#' @param Milestone (`length-1 character`) The name of the milestone.
#' @param IssueTestResults (`qcthat_IssueTestResults`) A data frame with issue
#'   test results for the milestone.
#'
#' @returns If `x` has rows, a character vector representing the tree that
#'   describes the milestones, issues, and tests in `x`. `NULL` otherwise.
#' @keywords internal
FormatMilestone <- function(Milestone, IssueTestResults) {
  n_issues <- nrow(IssueTestResults)
  return(c(
    glue::glue(
      ChooseTreeCharacter("branch"),
      ChooseTreeCharacter("horizontal"),
      ChooseTreeCharacter('box'),
      ChooseTreeCharacter("horizontal"),
      "Milestone: {Milestone} ({n_issues} issues)"
    ),
    FormatIssues(IssueTestResults)
  ))
}

#' Prepare the issues of a milestone for the qcthat_IssueTestMatrix output
#'
#' @inheritParams FormatMilestone
#' @returns A character vector representing the issues and their tests.
#' @keywords internal
FormatIssues <- function(IssueTestResults) {
  IssueTestResults$StateIndicator <- dplyr::case_match(
    IssueTestResults$StateReason,
    "completed" ~ ChooseEmoji("closed (completed)"),
    "not_planned" ~ ChooseEmoji("closed (won't fix)"),
    .default = ChooseEmoji("open")
  )
  lFormattedIssues <- purrr::pmap(IssueTestResults, FormatIssue)
  paste(ChooseTreeCharacter("vertical"), FinalizeTree(lFormattedIssues))
}

#' Prepare a single issue of a milestone for the qcthat_IssueTestMatrix output
#'
#' @param Issue (`length-1 integer`) The issue number.
#' @param Title (`length-1 character`) The issue title.
#' @param StateIndicator (`length-1 character`) The issue state indicator.
#' @param Type (`length-1 character`) The issue type.
#' @param TestResults (`data.frame`) A data frame with test results for the
#'   issue.
#' @param ... Additional arguments (not used).
#' @returns A character vector representing the issue and its tests.
#' @keywords internal
FormatIssue <- function(
  Issue,
  Title,
  StateIndicator,
  Type,
  TestResults,
  ...
) {
  return(c(
    FormatIssueHeader(Issue, StateIndicator, Title, Type),
    FormatTestResults(TestResults)
  ))
}

#' Prepare the issue itself for the qcthat_IssueTestMatrix output
#'
#' @inheritParams FormatIssue
#' @returns A length-1 character vector representing the issue header.
#' @keywords internal
FormatIssueHeader <- function(Issue, StateIndicator, Title, Type) {
  if (is.na(Issue)) {
    return(
      glue::glue(
        ChooseTreeCharacter("branch"),
        ChooseTreeCharacter("horizontal"),
        ChooseTreeCharacter("box"),
        ChooseTreeCharacter("horizontal"),
        "<no issue>"
      )
    )
  }
  return(
    glue::glue(
      ChooseTreeCharacter("branch"),
      ChooseTreeCharacter("horizontal"),
      ChooseTreeCharacter("box"),
      ChooseTreeCharacter("horizontal"),
      StateIndicator,
      ChooseTreeCharacter("horizontal"),
      "{Type} {Issue}: {Title}"
    )
  )
}

#' Prepare the test results for the qcthat_IssueTestMatrix output
#'
#' @inheritParams FormatIssue
#' @returns A character vector representing the issue's test results.
#' @keywords internal
FormatTestResults <- function(TestResults) {
  if (!length(TestResults)) {
    return(
      paste0(
        ChooseTreeCharacter("vertical"),
        "    ",
        ChooseTreeCharacter("elbow"),
        ChooseTreeCharacter("horizontal"),
        "(no tests)"
      )
    )
  }
  TestResults$DispositionIndicator <- dplyr::case_match(
    TestResults$Disposition,
    "pass" ~ ChooseEmoji("passed"),
    "fail" ~ ChooseEmoji("failed"),
    "skip" ~ ChooseEmoji("skipped"),
    .default = "[?]"
  )
  chrFormattedResults <- glue::glue(
    ChooseTreeCharacter("branch"),
    ChooseTreeCharacter("horizontal"),
    "{TestResults$DispositionIndicator}",
    ChooseTreeCharacter("horizontal"),
    "{TestResults$Test}"
  )
  paste0(
    ChooseTreeCharacter("vertical"),
    "    ",
    FinalizeTree(chrFormattedResults)
  )
}

#' Finalize a qcthat tree
#'
#' @param lTree (`list` of `character`) A list of character vectors representing
#'   parts of the qcthat report.
#' @returns A character vector representing the finalized tree structure.
#' @keywords internal
FinalizeTree <- function(lTree) {
  if (length(lTree)) {
    n <- length(lTree)
    # "Terminate" the tree.
    lTree[[n]][[1]] <- sub(
      paste0("^", ChooseTreeCharacter("branch")),
      ChooseTreeCharacter("elbow"),
      lTree[[n]][[1]]
    )
    # Remove extra bar from Children.
    lTree[[n]][-1] <- sub(
      paste0("^", ChooseTreeCharacter("vertical")),
      " ",
      lTree[[n]][-1]
    )
  }
  return(unlist(lTree))
}
