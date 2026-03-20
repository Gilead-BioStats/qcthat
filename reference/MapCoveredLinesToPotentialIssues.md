# Map covered source lines to potential issues

Map covered source lines to potential issues

## Usage

``` r
MapCoveredLinesToPotentialIssues(dfTestCoveredLines, dfIssueCommitsLong)
```

## Arguments

- dfTestCoveredLines:

  (`tibble`) Output of
  [`MapTestsToCoveredLines()`](https://gilead-biostats.github.io/qcthat/reference/MapTestsToCoveredLines.md).

- dfIssueCommitsLong:

  (`data.frame` or `NULL`) Pre-computed issue-commit mappings from
  [`MapLongIssueCommits()`](https://gilead-biostats.github.io/qcthat/reference/MapLongIssueCommits.md).
  If `NULL` (the default), fetched automatically from the GitHub API.
  Provide this when calling
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md)
  multiple times to avoid redundant API requests.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as
[`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md).
