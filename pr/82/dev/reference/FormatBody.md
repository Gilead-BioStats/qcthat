# Format the body of a qcthat object

Format the body of a qcthat object

## Usage

``` r
FormatBody(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))

# Default S3 method
FormatBody(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))

# S3 method for class 'qcthat_IssueTestMatrix'
FormatBody(x, ...)

# S3 method for class 'qcthat_Milestone'
FormatBody(x, ...)

# S3 method for class 'qcthat_SingleIssueTestResults'
FormatBody(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))
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

A character vector representing the formatted body of the object. By
default, if no method is defined for the object, the body is
[`format()`](https://rdrr.io/r/base/format.html) applied to the object
with the `"qcthat_object"` class removed.
