# Create a nested tibble of issues and tests

Combine the data from
[`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md)
and
[`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssues.md)
into a nested tibble organized by milestone, with each milestone
containing issues and associated tests.

## Usage

``` r
CompileIssueTestMatrix(dfRepoIssues, dfTestResults)
```

## Arguments

- dfRepoIssues:

  (`qcthat_Issues` or data frame) Data frame of GitHub issues as
  returned by
  [`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssues.md).

- dfTestResults:

  (`qcthat_TestResults` or data frame) Data frame of test results as
  returned by
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md).

## Value

A `qcthat_IssueTestMatrix` object, which is a tibble with columns:

- `Milestone`: The milestone title associated with the issues.

- `Issue`: Issue number.

- `Title`: Issue title.

- `Body`: Issue body (the full text of the issue).

- `Labels`: List column of character vectors of issue labels.

- `State`: Issue state (`open` or `closed`).

- `StateReason`: Reason for issue state (e.g., `completed`) or `NA` if
  not applicable.

- `Type`: Issue type or `"Issue"` if no issue type is available.

- `Url`: URL of the issue on GitHub.

- `ParentOwner`: GitHub username or organization name of the parent
  issue if applicable, otherwise `NA`.

- `ParentRepo`: GitHub repository name of the parent issue if
  applicable, otherwise `NA`.

- `ParentNumber`: GitHub issue number of the parent issue if applicable,
  otherwise `NA`.

- `CreatedAt`: `POSIXct` timestamp of when the issue was created.

- `ClosedAt`: `POSIXct` timestamp of when the issue was closed, or `NA`
  if the issue is still open.

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: File where the test is defined.

- `Disposition`: Factor with levels `pass`, `fail`, and `skip`
  indicating the overall outcome of the test.

## Examples

``` r
if (FALSE) { # interactive()
lTestResults <- testthat::test_local(
  stop_on_failure = FALSE,
  reporter = "silent"
)
CompileIssueTestMatrix(
  dfRepoIssues = FetchRepoIssues(),
  dfTestResults = CompileTestResults(lTestResults)
)
}
```
