# Extract disposition information from testthat results

Extract disposition information from testthat results

## Usage

``` r
CompileDispositions(lTestResults)
```

## Arguments

- lTestResults:

  (`testthat_results`) A testthat test results object, typically
  obtained by running something like
  [`testthat::test_local()`](https://testthat.r-lib.org/reference/test_package.html)
  with `stop_on_failure = FALSE` and a reporter that doesn't cause
  issues in parallel testing, like `reporter = "silent"`, and assigning
  it to a name.

## Value

A factor with levels `pass`, `fail`, and `skip`.
