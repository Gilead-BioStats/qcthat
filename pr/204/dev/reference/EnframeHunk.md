# Turn a hunk list into a tibble

Turn a hunk list into a tibble

## Usage

``` r
EnframeHunk(lHunk, strFilePath)
```

## Arguments

- lHunk:

  (`list`) A single element of `lBlameRaw$hunks` as returned by
  [`BlameFileRaw()`](https://gilead-biostats.github.io/qcthat/dev/reference/BlameFileRaw.md).

- strFilePath:

  (`length-1 character`) A file path.

## Value

A one-row
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `File`: The file name (character).

- `Line`: Line number (integer).

- `Commits`: List column where each element contains the commit SHA
  (character) that last modified that line.
