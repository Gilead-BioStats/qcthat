# Reorder data frame rows by vector

Reorder data frame rows by vector

## Usage

``` r
ReorderDFByVector(vecOrder, strName, dfUnique)
```

## Arguments

- vecOrder:

  A vector defining the desired order and repetitions.

- strName:

  (`length-1 character`) Name of the column in `dfUnique` to join on.

- dfUnique:

  (`data.frame`) Data frame with unique rows to be reordered.

## Value

A data frame with rows reordered to match `vecOrder`, including
duplicates.
