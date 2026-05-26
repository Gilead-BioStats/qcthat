# Compile issue test results by milestone

Compile issue test results by milestone

## Usage

``` r
CompileIssueTestResultsByMilestone(dfRepoIssues, dfTestResults)
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

A data frame with `IssueTestResults` nested by `Milestone`
