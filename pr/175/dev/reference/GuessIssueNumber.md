# Guess the relevant issue number from the GitHub event

Determine the issue number associated with the current GitHub event, if
the workflow was triggered by an `"issues"` event.

## Usage

``` r
GuessIssueNumber(lGHEventPayload = LoadGHEventPayload())
```

## Arguments

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/dev/reference/LoadGHEventPayload.md).

## Value

An integer representing the issue number (if the event payload contains
`issue$number` or `inputs$issueNumber`), or `NULL` if the event is not
an `"issues"` event or the issue number cannot be found.
