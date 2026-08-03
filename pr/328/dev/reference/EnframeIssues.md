# Transform issues list into tibble with expected columns

Transform issues list into tibble with expected columns

## Usage

``` r
EnframeIssues(lIssuesNonPR)
```

## Arguments

- lIssuesNonPR:

  (`list`) List of issue objects as returned by
  [`RemovePRsFromIssues()`](https://gilead-public.github.io/qcthat/dev/reference/RemovePRsFromIssues.md).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with raw issue data.
