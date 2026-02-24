# Gather potential issues into list column

Gather potential issues into list column

## Usage

``` r
GatherPotentialIssues(dfTestPotentialIssuesLong)
```

## Arguments

- dfTestPotentialIssuesLong:

  A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  in long format with one row per test-issue pair, typically from
  [`MapTestsToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapTestsToPotentialIssues.md).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the file where the test is defined, relative to the
  package root.

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssues`: List column containing integer vectors of issue
  numbers that might be related to each test based on commit history.
