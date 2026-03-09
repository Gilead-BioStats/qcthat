# Add a summary message to ITR footer

Add a summary message to ITR footer

## Usage

``` r
MakeITRDispositionFooter(x, lglUseEmoji = getOption("qcthat.emoji", TRUE))
```

## Arguments

- x:

  (`qcthat_Object`) The qcthat object to format.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A string summary message or `NULL` if no disposition is available.
