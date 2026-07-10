# Extract test information from test files

**\[experimental\]**

Parse test files in a directory to extract test descriptions, file
locations, line numbers, and associated GitHub issue numbers.

## Usage

``` r
ExtractTestsFromFiles(
  strTestDir = "tests/testthat",
  envCall = rlang::caller_env()
)
```

## Arguments

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the file where the test is defined, relative to the
  package root.

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
