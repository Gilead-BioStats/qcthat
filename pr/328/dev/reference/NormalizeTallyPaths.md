# Normalize tally paths to package-relative

Normalize tally paths to package-relative

## Usage

``` r
NormalizeTallyPaths(dfTally, strPkgRoot)
```

## Arguments

- dfTally:

  (`data.frame`) A tally data frame with a `filename` column.

- strPkgRoot:

  (`length-1 character`) Path to the package root.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with `SourceFile` (package-relative) and `Line` columns.
