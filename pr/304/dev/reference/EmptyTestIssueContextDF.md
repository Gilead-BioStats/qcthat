# Create empty test issue context data frame

Create empty test issue context data frame

## Usage

``` r
EmptyTestIssueContextDF()
```

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the file where the test is defined, relative to the
  package root.

- `LineStart`: Starting line number of test.

- `LineEnd`: Ending line number of test.

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssueDetails`: List column of tibbles with enriched issue
  details.

- `TestCode`: List column of character vectors containing test code.
