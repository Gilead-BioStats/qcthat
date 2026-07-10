# Transform comments list into tibble with expected columns

Transform comments list into tibble with expected columns

## Usage

``` r
EnframeComments(lCommentsRaw)
```

## Arguments

- lCommentsRaw:

  (`list`) List of raw comment objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with raw comments data.
