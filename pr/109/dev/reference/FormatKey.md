# Format the key for interpreting issue and test states

This is a placeholder. Eventually we should use dfITM to determine which
pieces of the key should be included.

## Usage

``` r
FormatKey(lglUseEmoji = getOption("qcthat.emoji", TRUE))
```

## Arguments

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A character vectore styled with
[`pillar::style_subtle()`](https://pillar.r-lib.org/reference/style_subtle.html).
