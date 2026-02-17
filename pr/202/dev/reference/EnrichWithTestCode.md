# Enrich data frame with test code

Enrich data frame with test code

## Usage

``` r
EnrichWithTestCode(dfTestPotentialIssueDetails, strTestDir)
```

## Arguments

- dfTestPotentialIssueDetails:

  (`tibble`) A data frame as returned by
  [`EnrichWithIssueDetails()`](https://gilead-biostats.github.io/qcthat/dev/reference/EnrichWithIssueDetails.md).

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

## Value

The input data frame with a `TestCode` list column added.
