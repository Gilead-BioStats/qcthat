#' Create a nested tibble of issues and tests
#'
#' Combine the data from [CompileTestResults()] and [FetchRepoIssues()] into a
#' nested tibble organized by milestone, with each milestone containing issues
#' and associated tests.
#'
#' @param dfRepoIssues (`qcthat_Issues` or data frame) Data frame of GitHub
#'   issues as returned by [FetchRepoIssues()].
#' @param dfTestResults (`qcthat_TestResults` or data frame) Data frame of test
#'   results as returned by [CompileTestResults()].
#'
#' @returns A `qcthat_IssueTestMatrix` object, which is a tibble with columns:
#'   - `Milestone`: The milestone title associated with the issues.
#'   - `Issue`: Issue number.
#'   - `Title`: Issue title.
#'   - `Body`: Issue body (the full text of the issue).
#'   - `Labels`: List column of character vectors of issue labels.
#'   - `State`: Issue state (`open` or `closed`).
#'   - `StateReason`: Reason for issue state (e.g., `completed`) or `NA` if not
#'   applicable.
#'   - `Type`: Issue type or `"Issue"` if no issue type is available.
#'   - `Url`: URL of the issue on GitHub.
#'   - `ParentOwner`: GitHub username or organization name of the parent issue
#'   if applicable, otherwise `NA`.
#'   - `ParentRepo`: GitHub repository name of the parent issue if applicable,
#'   otherwise `NA`.
#'   - `ParentNumber`: GitHub issue number of the parent issue if applicable,
#'   otherwise `NA`.
#'   - `CreatedAt`: `POSIXct` timestamp of when the issue was created.
#'   - `ClosedAt`: `POSIXct` timestamp of when the issue was closed, or `NA` if
#'   the issue is still open.
#'   - `Test`: The `desc` field of the test from [testthat::test_that()].
#'   - `File`: File where the test is defined.
#'   - `Disposition`: Factor with levels `pass`, `fail`, and `skip` indicating
#'   the overall outcome of the test.
#' @export
#'
#' @examplesIf interactive()
#' lTestResults <- testthat::test_local(stop_on_failure = FALSE)
#' CompileIssueTestMatrix(
#'   dfRepoIssues = FetchRepoIssues(),
#'   dfTestResults = CompileTestResults(lTestResults)
#' )
CompileIssueTestMatrix <- function(dfRepoIssues, dfTestResults) {
  AsIssueTestMatrix(
    CompileIssueTestResultsByMilestone(
      dfRepoIssues,
      dfTestResults
    )
  )
}

#' Assign the qcthat_IssueTestMatrix class to a data frame
#'
#' @inheritParams AsExpected
#' @returns A `qcthat_IssueTestMatrix` object.
#' @keywords internal
AsIssueTestMatrix <- function(x) {
  AsExpected(
    x,
    EmptyIssueTestMatrix(),
    chrClass = "qcthat_IssueTestMatrix"
  )
}


#' Compile issue test results by milestone
#'
#' @inheritParams CompileIssueTestMatrix
#' @returns A data frame with `IssueTestResults` nested by `Milestone`
#' @keywords internal
CompileIssueTestResultsByMilestone <- function(dfRepoIssues, dfTestResults) {
  dfITRbyM <- dplyr::full_join(
    AsIssuesDF(dfRepoIssues),
    ExpandTestResultsByIssue(dfTestResults),
    by = "Issue"
  ) |>
    dplyr::arrange(.data$Milestone, dplyr::desc(.data$Issue)) |>
    dplyr::relocate("Milestone")
  class(dfITRbyM) <- class(tibble::tibble())
  return(dfITRbyM)
}

#' Unnest test results
#'
#' @inheritParams CompileIssueTestMatrix
#' @returns A tibble with `"Issues"` from [AsTestResultsDF()] unnested into
#'   `"Issue"`, and the `"Issue"` column first.
#' @keywords internal
ExpandTestResultsByIssue <- function(dfTestResults) {
  tidyr::unnest_longer(
    # Confirm that dfTestResults is a TestResults object.
    AsTestResultsDF(dfTestResults),
    "Issues",
    values_to = "Issue",
    keep_empty = TRUE
  ) |>
    dplyr::relocate("Issue")
}

#' Empty issue test results data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyIssueTestMatrix <- function() {
  dplyr::full_join(
    AsIssuesDF(NULL),
    ExpandTestResultsByIssue(NULL),
    by = "Issue"
  ) |>
    dplyr::relocate("Milestone")
}
