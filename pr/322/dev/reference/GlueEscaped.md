# Glue without collisions of curly braces

Glue without collisions of curly braces

## Usage

``` r
GlueEscaped(
  ...,
  .sep = "\n\n",
  .open = "qcthatopen{",
  .close = "}qcthatclose",
  .envir = rlang::caller_env()
)
```

## Arguments

- ...:

  Values to glue and/or additional arguments passed to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).

- .sep:

  (`length-1 character`) Separator to use between glued values.

- .open:

  (`length-1 character`) Opening delimiter. Defaults value avoids
  collisions.

- .close:

  (`length-1 character`) Closing delimiter. Defaults value avoids
  collisions.

- .envir:

  (`environment`) Environment to evaluate expressions in.

## Value

The glued expression as a length-1 character vector.
