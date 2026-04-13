# Turn a hunk list into a tibble

Turn a hunk list into a tibble

## Usage

``` r
EnframeHunk(lHunk, strFilePath, envCall = rlang::caller_env())
```

## Arguments

- lHunk:

  (`list`) A single element of `lBlameRaw$hunks` as returned by
  [`BlameFileRaw()`](https://gilead-biostats.github.io/qcthat/reference/BlameFileRaw.md).

- strFilePath:

  (`length-1 character`) A file path.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A one-row
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `File`: Path to the file, relative to the package root.

- `Line`: Line number (integer).

- `Commits`: List column where each element contains the commit SHA
  (character) that last modified that line.
