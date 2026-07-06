# Read test file contents once per unique file

Read test file contents once per unique file

## Usage

``` r
ReadTestFileContents(dfFileTests)
```

## Arguments

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).

## Value

A named list of character vectors, keyed by file path.
