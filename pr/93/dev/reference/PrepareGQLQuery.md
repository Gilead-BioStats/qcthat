# Prepare a GraphQL query string

Prepare a GraphQL query string

Prepare a GraphQL query string

## Usage

``` r
PrepareGQLQuery(
  ...,
  strOpen = "<",
  strClose = ">",
  envCall = rlang::caller_env()
)

PrepareGQLQuery(
  ...,
  strOpen = "<",
  strClose = ">",
  envCall = rlang::caller_env()
)
```

## Arguments

- ...:

  (`character`) Lines of the query.

- strOpen:

  (`length-1 character`) The opening delimiter for
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).

- strClose:

  (`length-1 character`) The closing delimiter for
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).

## Value

A single character string containing the formatted query.

A single character string containing the formatted query.
