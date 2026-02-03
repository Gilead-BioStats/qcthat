# Guess the relevant release id from the GitHub event

Determine the release id associated with the current GitHub event, if
the workflow was triggered by a `"release"` event, or by a
`"workflow_dispatch"` event with `"tag"` input

## Usage

``` r
GuessReleaseID(
  lGHEventPayload = LoadGHEventPayload(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/dev/reference/LoadGHEventPayload.md).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A string or number representing the release id (if the event payload
contains `release$id`, `release$tag_name`, or `inputs$tag`), or `NULL`
if the event is not a `"release"` event or the release id cannot be
found.
