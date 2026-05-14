# Convenience function to glue data and collapse with a separator

Convenience function to glue data and collapse with a separator

## Usage

``` r
CollapseGluedData(dfData, ..., strSep = "\n")
```

## Arguments

- dfData:

  (`data.frame` or `list`) Data frame or list to use as the data source
  for
  [`glue::glue_data()`](https://glue.tidyverse.org/reference/glue.html).

- ...:

  Expressions to evaluate within the context of `dfData`, passed to
  [`glue::glue_data()`](https://glue.tidyverse.org/reference/glue.html).

- strSep:

  (`length-1 character`) Separator to use between glued values. Defaults
  to a newline, which is common for formatting multiple lines of text in
  GitHub comments.

## Value

A string containing the glued and collapsed result.
