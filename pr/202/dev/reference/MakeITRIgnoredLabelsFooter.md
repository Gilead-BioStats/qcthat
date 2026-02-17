# Add an ignored issue summary message to ITR footer

Add an ignored issue summary message to ITR footer

## Usage

``` r
MakeITRIgnoredLabelsFooter(
  lIgnoredIssues,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  lglShowIgnoredLabels = TRUE
)
```

## Arguments

- lIgnoredIssues:

  (`list`) A named list of integer vectors, where each name is an
  ignored label and each integer vector contains the issue numbers that
  were ignored for that label.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

- lglShowIgnoredLabels:

  (`length-1 logical`) Whether to show information in reports about
  issue labels (such as `"qcthat-nocov"`) that have been ignored.

## Value

A string summary messages or `NULL` if no ignored issues are present.
