# Extract test information from test files

Parse test files in a directory to extract test descriptions, file
locations, line numbers, and associated GitHub issue numbers.

## Usage

``` r
ExtractTestsFromFiles(strTestDir = "tests/testthat")
```

## Arguments

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: File where the test is defined.

- `LineStart`: First line of the test.

- `LineEnd`: Last line of the test.

- `Issues`: List column containing integer vectors of associated GitHub
  issue numbers.

- `TaggedNoIssue`: Logical indicating whether the test is tagged with
  `#noissue`.

## Examples

``` r
if (FALSE) { # interactive()

  # Extract all tests
  ExtractTestsFromFiles()

  # Find tests with no linked issues
  ExtractTestsFromFiles() |>
    dplyr::filter(!lengths(Issues), !TaggedNoIssue)
}
```
