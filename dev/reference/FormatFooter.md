# Format the footer of a qcthat object

Format the footer of a qcthat object

## Usage

``` r
FormatFooter(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))

# Default S3 method
FormatFooter(x, ...)

# S3 method for class 'qcthat_IssueTestMatrix'
FormatFooter(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))
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

## Value

A character vector representing the formatted footer of the object. By
default, if no method is defined for the object, no footer is printed.
