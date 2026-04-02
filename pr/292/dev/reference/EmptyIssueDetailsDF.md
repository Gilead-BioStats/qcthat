# Create empty issue details data frame

Create empty issue details data frame

## Usage

``` r
EmptyIssueDetailsDF()
```

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Issue`: Issue number.

- `Title`: Issue title.

- `Body`: Issue body (or `NA_character_` if NULL).
