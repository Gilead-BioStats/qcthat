# Unnest test results

Unnest test results

## Usage

``` r
ExpandTestResultsByIssue(dfTestResults)
```

## Arguments

- dfTestResults:

  (`qcthat_TestResults` or data frame) Data frame of test results as
  returned by
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md).

## Value

A tibble with `"Issues"` from
[`AsTestResultsDF()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsTestResultsDF.md)
unnested into `"Issue"`, and the `"Issue"` column first.
