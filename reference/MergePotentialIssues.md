# Merge two sets of potential issues per test

Union `PotentialIssues` from two data frames (e.g., test-blame and
source-blame) per test, deduplicating and sorting.

## Usage

``` r
MergePotentialIssues(dfA, dfB)
```

## Arguments

- dfA:

  (`tibble`) First potential issues data frame.

- dfB:

  (`tibble`) Second potential issues data frame.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as
[`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md),
with `PotentialIssues` unioned.
