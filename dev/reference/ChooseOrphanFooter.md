# Choose orphan footer

Choose orphan footer

## Usage

``` r
ChooseOrphanFooter(
  intIssues,
  chrTests,
  lglUseEmoji = getOption("qcthat.emoji", TRUE)
)
```

## Arguments

- intIssues:

  (`integer`) A vector of issue numbers from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  matrix or from GitHub.

- chrTests:

  (`character`) A vector of test descriptions from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  matrix.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

## Value

A string with or without an emoji describing test linkage to issues, or
`NULL` if there aren't any tests.
