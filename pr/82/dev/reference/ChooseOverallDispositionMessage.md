# Add a summary message to ITR footer

Add a summary message to ITR footer

## Usage

``` r
ChooseOverallDispositionMessage(fctDisposition)
```

## Arguments

- fctDisposition:

  (`factor`) Disposition factor with levels `c("fail", "skip", "pass")`.

## Value

A string summary message or `NULL` if no disposition is available.
