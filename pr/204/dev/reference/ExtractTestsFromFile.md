# Extract test information from a single file

Extract test information from a single file

## Usage

``` r
ExtractTestsFromFile(strFilePath)
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as
[`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).
