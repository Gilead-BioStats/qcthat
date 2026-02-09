# Choose emoji to indicate test disposition

Choose emoji to indicate test disposition

## Usage

``` r
ChooseDispositionIndicator(
  chrDisposition,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
)
```

## Arguments

- chrDisposition:

  (`character`) Test disposition. Generally one of `"pass"`, `"fail"`,
  or `"skip"`.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A character vector of the same length as `chrDisposition`, with each
element being the emoji or ASCII indicator for the corresponding test
disposition.
