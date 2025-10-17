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
#' @returns A `qcthat_IssueTestMatrix` object, which is a nested tibble with
#'   columns:
#'   - `Milestone`: The milestone title associated with the issues.
#'   - `IssueTestResults`: A nested tibble with the other columns returned by
#'   [FetchRepoIssues()], plus `TestResults`, which is a nested tibble with
#'   the remaining columns from [CompileTestResults()].
#' @export
#'
#' @examplesIf interactive()
#'   lTestResults <- testthat::test_local(stop_on_failure = FALSE)
#'   CompileIssueTestMatrix(
#'     dfRepoIssues = FetchRepoIssues(),
#'     dfTestResults = CompileTestResults(lTestResults)
#'   )
CompileIssueTestMatrix <- function(dfRepoIssues, dfTestResults) {
  AsIssueTestMatrix(
    CompileIssueTestResultsByMilestone(
      AsIssuesDF(dfRepoIssues),
      CompileTestResultsByIssue(dfTestResults)
    )
  )
}

#' Assign the qcthat_IssueTestMatrix class to a data frame
#'
#' @inheritParams AsExpectedDF
#' @returns A `qcthat_IssueTestMatrix` object.
#' @keywords internal
AsIssueTestMatrix <- function(df) {
  AsExpectedDF(
    df,
    tibble::tibble(
      Milestone = character(),
      IssueTestResults = list()
    ),
    chrClass = "qcthat_IssueTestMatrix"
  )
}

#' Compile test results by issue
#'
#' @inheritParams CompileIssueTestMatrix
#' @returns A data frame with `TestResults` nested by `Issue`
#' @keywords internal
CompileTestResultsByIssue <- function(dfTestResults) {
  tidyr::unnest_longer(
    AsTestResultsDF(dfTestResults),
    "Issues",
    values_to = "Issue",
    keep_empty = TRUE
  ) |>
    tidyr::nest(.by = "Issue", .key = "TestResults")
}

#' Compile issue test results by milestone
#'
#' @param dfTestResultsByIssue (`data.frame`) Data frame with `TestResults`
#'   nested by `Issue`, as returned by [CompileTestResultsByIssue()].
#' @inheritParams CompileIssueTestMatrix
#' @returns A data frame with `IssueTestResults` nested by `Milestone`
#' @keywords internal
CompileIssueTestResultsByMilestone <- function(
  dfRepoIssues,
  dfTestResultsByIssue
) {
  dplyr::left_join(
    dfRepoIssues,
    dfTestResultsByIssue,
    by = "Issue"
  ) |>
    tidyr::nest(
      .by = "Milestone",
      .key = "IssueTestResults"
    )
}
