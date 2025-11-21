# General printing/formatting ----

#' Printing qcthat objects
#'
#' One of the main purposes of qcthat is to produce user-friendly reports about
#' a package's issue and test statuses. Printing an issue-test matrix provides a
#' nested view of the relationship between milestones, issues, and tests, as
#' well as the state of issues ("open", "closed (completed)", or "closed (won't
#' fix)") and the disposition of tests ("passed", "failed", or "skipped").
#'
#' @param x (`qcthat_Object`) The qcthat object to format.
#' @param fnTransform (`function`) A function to transform the output before
#'   returning it. By default, this is [base::identity()] for `format()`
#'   (returns the formatted output), and [base::writeLines()] for `print()`
#'   (sends the output to [stdout()]).
#' @param ... Additional arguments passed to methods.
#' @inheritParams shared-params
#' @examplesIf interactive()
#'
#'   lTestResults <- testthat::test_local(
#'     stop_on_failure = FALSE,
#'     reporter = "silent"
#'   )
#'   IssueTestMatrix <- CompileIssueTestMatrix(
#'     dfRepoIssues = FetchRepoIssues(),
#'     dfTestResults = CompileTestResults(lTestResults)
#'   )
#'   print(IssueTestMatrix)
#'
#'   # Remove the "qcthat_IssueTestMatrix" class to see the raw tibble.
#'   print(tibble::as_tibble(IssueTestMatrix))
#'
#' @name printing
NULL

#' @rdname printing
#' @export
print.qcthat_Object <- function(x, ...) {
  # The `fnTransform` argument causes the output to be printed to stdout as a
  # side effect rather than returned. This method is borrowed from {pillar},
  # which is what {tibble} uses for printing/formatting.
  format(x, ..., fnTransform = writeLines)
  invisible(x)
}

#' @rdname printing
#' @export
format.qcthat_Object <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  lglShowMilestones = TRUE,
  fnTransform = identity
) {
  fnTransform(
    c(
      FormatHeader(
        x,
        lglUseEmoji = lglUseEmoji,
        lglShowMilestones = lglShowMilestones
      ),
      FormatBody(
        x,
        lglUseEmoji = lglUseEmoji,
        lglShowMilestones = lglShowMilestones
      ),
      FormatFooter(x, lglUseEmoji = lglUseEmoji)
    ),
    # Allow users to pass in fnTransform args, notably `con` for `writeLines`.
    ...
  )
}

# Format helpers ----

#' Format the header of a qcthat object
#'
#' @inheritParams printing
#' @returns A character vector representing the formatted header of the object.
#'   By default, if no method is defined for the object, no header is printed.
#' @name FormatHeader
#' @keywords internal
FormatHeader <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  UseMethod("FormatHeader")
}

#' @rdname FormatHeader
#' @export
FormatHeader.default <- function(x, ...) {
  NULL
}

#' Format the body of a qcthat object
#'
#' @inheritParams printing
#' @returns A character vector representing the formatted body of the object. By
#'   default, if no method is defined for the object, the body is [format()]
#'   applied to the object with the `"qcthat_object"` class removed.
#' @name FormatBody
#' @keywords internal
FormatBody <- function(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE)) {
  UseMethod("FormatBody")
}

#' @rdname FormatBody
#' @export
FormatBody.default <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  class(x) <- setdiff(class(x), "qcthat_Object")
  format(x, ...)
}

#' Format the footer of a qcthat object
#'
#' @inheritParams printing
#' @returns A character vector representing the formatted footer of the object.
#'   By default, if no method is defined for the object, no footer is printed.
#' @name FormatFooter
#' @keywords internal
FormatFooter <- function(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  UseMethod("FormatFooter")
}

#' @rdname FormatFooter
#' @export
FormatFooter.default <- function(x, ...) {
  NULL
}

# Format/print utilities ----

#' Helper to insert emojis into footer key items
#'
#' @param strCondition (`length-1 character`) The condition to create a key item
#'   for.
#' @inheritParams shared-params
#' @returns A length-1 character vector representing the key item with an emoji.
#' @keywords internal
MakeKeyItem <- function(
  strCondition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
) {
  strEmoji <- ChooseEmoji(strCondition, lglUseEmoji = lglUseEmoji)
  glue::glue("{strEmoji} = {strCondition}")
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
  if (lglUseEmoji && rlang::is_installed("emoji")) {
    chrEmoji <- c(
      open = "inbox_tray",
      `closed (completed)` = "check_box_with_check",
      `closed (won't fix)` = "no_entry",
      passed = "white_check_mark",
      failed = "cross_mark",
      skipped = "no_entry_sign",
      covered = "green_circle",
      uncovered = "hollow_red_circle",
      orphaned = "broken_chain"
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
      skipped = "[S]",
      covered = "[#]",
      uncovered = "[ ]",
      orphaned = "[~]"
    )
    chrASCII[[strCondition]]
  }
}

#' Helper to translate tree characters to codes by name
#'
#' R CMD check doesn't like these characters appearing "raw", and they're hard
#' to read as U codes, so encode them in one place.
#'
#' @param strCharacterDescription (`length-1 character`) The special character
#'   to choose.
#' @returns A length-1 character vector representing the chosen tree character.
#' @keywords internal
GetChrCode <- function(strCharacterDescription) {
  chrTreeCharacters <- c(
    box = "\U2588",
    branch = "\U251C",
    horizontal = "\U2500",
    vertical = "\U2502",
    elbow = "\U2514"
  )
  chrTreeCharacters[[strCharacterDescription]]
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
    chrBranches <- paste0(
      c(rep(GetChrCode("branch"), n - 1), GetChrCode("elbow")),
      GetChrCode("horizontal")
    )
    chrChildIndenters <- paste0(c(rep(GetChrCode("vertical"), n - 1), " "), " ")
    lTree <- purrr::pmap(
      list(lTree, chrBranches, chrChildIndenters),
      function(chrSubTree, strBranch, strChildIndent) {
        paste0(
          c(strBranch, rep(strChildIndent, length(chrSubTree) - 1)),
          chrSubTree
        )
      }
    )
  }
  return(unlist(lTree))
}
