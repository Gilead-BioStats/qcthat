# Extract issue numbers from test descriptions

Extract issue numbers from test descriptions

## Usage

``` r
ExtractTestIssues(chrTests)
```

## Arguments

- chrTests:

  (`character`) A vector of test descriptions from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  matrix or extracted from test files.

## Value

A list of integer vectors of sorted unique issue numbers.
