# Convert raw GitHub labels list to data frame

Convert raw GitHub labels list to data frame

## Usage

``` r
EnframeGHLabels(lGHLabels)
```

## Arguments

- lGHLabels:

  (`list`) List of label objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns `Label`, `Description`, and `Color`, or `NULL` if
`lGHLabels` is empty.
