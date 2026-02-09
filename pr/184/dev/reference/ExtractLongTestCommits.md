# Extract test-commit pairs in long format

Extract test-commit pairs in long format

## Usage

``` r
ExtractLongTestCommits(strTestDir = "tests/testthat")
```

## Arguments

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with one row per test-commit pair, containing columns `Test`, `File`,
`LineStart`, `LineEnd`, `Issues`, and `Commits`.
