# Add a summary message to ITR footer

Add a summary message to ITR footer

## Usage

``` r
MakeITRDispositionFooter(
  fctDisposition,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
)
```

## Arguments

- fctDisposition:

  (`factor`) Disposition factor with levels `c("fail", "skip", "pass")`.

- ...:

  Additional arguments passed to methods.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A string summary message or `NULL` if no disposition is available.
