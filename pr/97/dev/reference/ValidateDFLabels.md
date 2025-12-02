# Validate the labels data frame

Validate the labels data frame

## Usage

``` r
ValidateDFLabels(dfLabels)
```

## Arguments

- dfLabels:

  (`data.frame`) A data frame with columns `Label`, `Description`, and
  `Color`, specifying the labels to create. By default, this is the data
  frame returned by
  [`DefaultIgnoreLabelsDF()`](https://gilead-biostats.github.io/qcthat/dev/reference/DefaultIgnoreLabelsDF.md).
  Descriptions of labels created via this function are prefixed with
  `"{qcthat}: "` to make it easier to search for them in your list of
  labels.

## Value

`NULL` (invisibly). Errors if the data frame is invalid.
