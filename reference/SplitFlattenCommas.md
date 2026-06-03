# Flatten a character vector of comma-separated values

Flatten a character vector of comma-separated values

## Usage

``` r
SplitFlattenCommas(chrVector)
```

## Arguments

- chrVector:

  (`character`) The character vector to split. If any element contains
  commas, it will be split, and spaces around the commas will be
  removed.

## Value

A character vector with the elements of `chrVector` split by commas and
flattened into a single vector.
