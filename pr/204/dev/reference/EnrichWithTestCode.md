# Enrich data frame with test code

Enrich data frame with test code

## Usage

``` r
EnrichWithTestCode(dfTestPotentialIssueDetails)
```

## Arguments

- dfTestPotentialIssueDetails:

  (`tibble`) A data frame as returned by
  [`EnrichWithIssueDetails()`](https://gilead-biostats.github.io/qcthat/dev/reference/EnrichWithIssueDetails.md).

## Value

The input data frame with a `TestCode` list column added.
