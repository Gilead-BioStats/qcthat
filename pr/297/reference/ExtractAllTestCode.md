# Extract test code blocks for all tests

Extract test code blocks for all tests

## Usage

``` r
ExtractAllTestCode(dfFileTests, chrFileContents)
```

## Arguments

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/reference/ExtractTestsFromFiles.md).

- chrFileContents:

  (`list`) Named list of file contents from
  [`ReadTestFileContents()`](https://gilead-biostats.github.io/qcthat/reference/ReadTestFileContents.md).

## Value

A list of character vectors, one per test.
