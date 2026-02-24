# Extract test information from a single file

Extract test information from a single file

## Usage

``` r
ExtractTestsFromFile(strFilePath, envCall = rlang::caller_env())
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as
[`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/reference/ExtractTestsFromFiles.md).
