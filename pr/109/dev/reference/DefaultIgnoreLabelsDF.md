# Default ignored labels as a tibble

Returns a tibble of ignore labels (from
[`DefaultIgnoreLabels()`](https://gilead-biostats.github.io/qcthat/dev/reference/DefaultIgnoreLabels.md)),
their descriptions, and the colors of their labels.

## Usage

``` r
DefaultIgnoreLabelsDF()
```

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns `Label`, `Description`, and `Color`.

## Examples

``` r
DefaultIgnoreLabelsDF()
#> # A tibble: 2 × 3
#>   Label        Description                                   Color  
#>   <chr>        <chr>                                         <chr>  
#> 1 qcthat-nocov Do not include in issue-test coverage reports #444444
#> 2 qcthat-uat   Special issues for user acceptance testing    #444444
```
