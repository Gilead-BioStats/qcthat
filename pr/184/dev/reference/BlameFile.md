# Git blame a file

Git blame a file

## Usage

``` r
BlameFile(strFilePath)
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `File`: The file name (character).

- `Line`: Line number (integer).

- `Commits`: List column where each element contains the commit SHA
  (character) that last modified that line.
