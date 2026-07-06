# Stretch LineStart and LineEnd to Line rows

Stretch LineStart and LineEnd to Line rows

## Usage

``` r
ExpandLines(dfFileTests)
```

## Arguments

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as `dfFileTests`, but with a new integer column
`Line`, and one row per line.
