# Split a data frame by rows and transform

Split a data frame by rows and transform

## Usage

``` r
AsRowDFList(df, fnAsDF)
```

## Arguments

- df:

  (`data.frame`) Data frame to split by rows.

- fnAsDF:

  (`function`) Function to apply to each single-row data frame.

## Value

A list of objects, each processed via `fnAsDF`.
