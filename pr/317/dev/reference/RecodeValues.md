# Choose between recode functions based on dplyr version

Choose between recode functions based on dplyr version

## Usage

``` r
RecodeValues(x, ..., default = NULL)
```

## Arguments

- x:

  (`vector`) The vector to recode.

- ...:

  Recode pairs in the form of `old ~ new`. See
  [`dplyr::case_match()`](https://dplyr.tidyverse.org/reference/case_match.html)
  or
  [`dplyr::recode_values()`](https://dplyr.tidyverse.org/reference/recode-and-replace-values.html)
  for details.

- default:

  (`scalar`) The default value to use for unmatched cases. See
  [`dplyr::case_match()`](https://dplyr.tidyverse.org/reference/case_match.html)
  or
  [`dplyr::recode_values()`](https://dplyr.tidyverse.org/reference/recode-and-replace-values.html)
  for details.

## Value

A vector with the same size as `x` with values recoded according to the
specified pairs and default.
