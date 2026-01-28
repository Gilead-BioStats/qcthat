# Get the PR number for a GitHub Action

Get the PR number for a GitHub Action

## Usage

``` r
GetGHAPRNumber(lGHEventPayload = LoadGHEventPayload())
```

## Arguments

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/dev/reference/LoadGHEventPayload.md).

## Value

An integer pull request number, or `NULL` if not running in a
PR-triggered action (as indicated by the environment variables
`"GITHUB_EVENT_NAME"` and `"GITHUB_REF_NAME"`).
