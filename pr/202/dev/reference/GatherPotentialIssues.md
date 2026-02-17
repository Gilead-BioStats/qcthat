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

- `Test`: Test description (character).

- `File`: Test file name (character).

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssues`: List column containing integer vectors of issue
  numbers that might be related to each test based on commit history.
