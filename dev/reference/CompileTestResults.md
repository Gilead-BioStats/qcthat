# Extract information from testthat results

Extract relevant information from a `testthat_results` object into a
tidy
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Usage

``` r
CompileTestResults(lTestResults)
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

A `qcthat_TestResults` object, which is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: File where the test is defined.

- `Disposition`: Factor with levels `pass`, `fail`, and `skip`
  indicating the overall outcome of the test.

- `Issues`: List column containing integer vectors of associated GitHub
  issue numbers.

## Examples

``` r
# Generate a test results object.

# lTestResults <- testthat::test_local(
#  stop_on_failure = FALSE,
#  reporter = "silent"
# )

lTestResults <- structure(
  list(
    list(
      file = "test-file1.R",
      test = "First test with one GH issue (#32)",
      results = list(
        structure(
          list(),
          class = c("expectation_success", "expectation", "condition")
        )
      )
    ),
    list(
      file = "test-file1.R",
      test = "Second test with two GH issues (#32, #45)",
      results = list(
        structure(
          list(),
          class = c("expectation_failure", "expectation", "error", "condition")
        )
      )
    )
  ),
  class = "testthat_results"
)
CompileTestResults(lTestResults)
#> # A tibble: 2 × 4
#>   Test                                      File         Disposition Issues   
#> * <chr>                                     <chr>        <fct>       <list>   
#> 1 First test with one GH issue (#32)        test-file1.R pass        <int [1]>
#> 2 Second test with two GH issues (#32, #45) test-file1.R fail        <int [2]>
```
