# Printing qcthat objects

One of the main purposes of qcthat is to produce user-friendly reports
about a package's issue and test statuses. Printing an issue-test matrix
provides a nested view of the relationship between milestones, issues,
and tests, as well as the state of issues ("open", "closed (completed)",
or "closed (won't fix)") and the disposition of tests ("passed",
"failed", or "skipped").

## Usage

``` r
# S3 method for class 'qcthat_Object'
print(x, ...)

# S3 method for class 'qcthat_Object'
format(
  x,
  ...,
  lglUseEmoji = getOption("qcthat.emoji", TRUE),
  fnTransform = identity
)
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

- fnTransform:

  (`function`) A function to transform the output before returning it.
  By default, this is
  [`base::identity()`](https://rdrr.io/r/base/identity.html) for
  [`format()`](https://rdrr.io/r/base/format.html) (returns the
  formatted output), and
  [`base::writeLines()`](https://rdrr.io/r/base/writeLines.html) for
  [`print()`](https://rdrr.io/r/base/print.html) (sends the output to
  [`stdout()`](https://rdrr.io/r/base/showConnections.html)).

## Examples

``` r
if (FALSE) { # interactive()

  lTestResults <- testthat::test_local(
    stop_on_failure = FALSE,
    reporter = "silent"
  )
  IssueTestMatrix <- CompileIssueTestMatrix(
    dfRepoIssues = FetchRepoIssues(),
    dfTestResults = CompileTestResults(lTestResults)
  )
  print(IssueTestMatrix)

  # Remove the "qcthat_IssueTestMatrix" class to see the raw tibble.
  print(tibble::as_tibble(IssueTestMatrix))
}
```
