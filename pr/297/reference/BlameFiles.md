# Git blame multiple files

Git blame multiple files

## Usage

``` r
BlameFiles(chrFilePaths, envCall = rlang::caller_env())
```

## Arguments

- chrFilePaths:

  (`character`) Paths to files to blame.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as
[`BlameFile()`](https://gilead-biostats.github.io/qcthat/reference/BlameFile.md),
row-bound across all files.
