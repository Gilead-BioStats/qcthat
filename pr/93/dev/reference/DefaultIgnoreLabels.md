# Default labels to ignore

Returns the character vector of issue labels that are ignored by default
in QC reports. Currently, this list only includes `"qcthat-nocov"`, but
it may change as we add more standard labels.

## Usage

``` r
DefaultIgnoreLabels()
```

## Value

A character vector of label names.

## Examples

``` r
DefaultIgnoreLabels()
#> [1] "qcthat-nocov"
```
