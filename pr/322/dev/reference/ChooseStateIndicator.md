# Choose an emoji to indicate issue state

Choose an emoji to indicate issue state

## Usage

``` r
ChooseStateIndicator(
  strStateReason,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
)
```

## Arguments

- strStateReason:

  (`length-1 character`) Reason for issue state (e.g., `completed`) or
  `NA` if not applicable.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A length-1 character vector representing the emoji or ASCII indicator
for the given condition.
