# Helper to choose emojis or ASCII indicators

Helper to choose emojis or ASCII indicators

## Usage

``` r
ChooseEmoji(strCondition, lglUseEmoji = getOption("qcthat.emoji", TRUE))
```

## Arguments

- strCondition:

  (`length-1 character`) The condition to create a key item for.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A length-1 character vector representing the emoji or ASCII indicator
for the given condition.
