# Add a summary message to ITR footer

Add a summary message to ITR footer

## Usage

``` r
ChooseOverallDispositionIndicator(
  fctDisposition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
)
```

## Arguments

- fctDisposition:

  (`factor`) Disposition factor with levels `c("fail", "skip", "pass")`.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

An emoji or other string indicating the overall disposition of all
tests.
