# Format a non-empty SingleIssueTestResults header

Format a non-empty SingleIssueTestResults header

## Usage

``` r
FormatSITRHeader(x, lglUseEmoji = getOption("qcthat.emoji", TRUE))
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

A formatted string for the SingleIssueTestResults header.
