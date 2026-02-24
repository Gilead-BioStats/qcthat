# Guess relevant milestone names from the GitHub event

Determine the name of any milestones associated with the current GitHub
event, if the workflow was triggered by a `"pull_request"` or
`"release"` event, or by a `"workflow_dispatch"` event with
`"milestone"` input.

## Usage

``` r
GuessMilestones(lGHEventPayload = LoadGHEventPayload())
```

## Arguments

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/reference/LoadGHEventPayload.md).

## Value

A character vector of milestone names (if the event payload contains
`pull_request$milestone$title`, `release$name`, `release$tag_name`, or
`inputs$milestone`), or `NULL` if no milestone names can found.
