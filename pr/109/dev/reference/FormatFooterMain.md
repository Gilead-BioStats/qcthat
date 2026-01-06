# Format the non-key portion of the footer

This is a placeholder. Ideally it should probably also be an S3 generic,
or otherwise have a more specific name.

## Usage

``` r
FormatFooterMain(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  lglShowIgnoredLabels = TRUE
)
```

## Arguments

- x:

  (`qcthat_Object`) The qcthat object to format.

- ...:

  Additional arguments passed to methods.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

- lglShowIgnoredLabels:

  (`length-1 logical`) Whether to show information in reports about
  issue labels (such as `"qcthat-nocov"`) that have been ignored.

## Value

A character vector representing the formatted footer main body.
