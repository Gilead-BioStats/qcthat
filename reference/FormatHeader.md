# Format the header of a qcthat object

Format the header of a qcthat object

## Usage

``` r
FormatHeader(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))

# Default S3 method
FormatHeader(x, ...)

# S3 method for class 'qcthat_IssueTestMatrix'
FormatHeader(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  lglShowMilestones = TRUE
)

# S3 method for class 'qcthat_Milestone'
FormatHeader(x, ...)

# S3 method for class 'qcthat_SingleIssueTestResults'
FormatHeader(x, ..., lglUseEmoji = getOption("qcthat.emoji", TRUE))
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

- lglShowMilestones:

  (`length-1 logical`) Whether to separate issues by milestones in
  reports.

## Value

A character vector representing the formatted header of the object. By
default, if no method is defined for the object, no header is printed.
