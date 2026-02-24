# Get the PR number for a GitHub Action

Get the PR number for a GitHub Action

## Usage

``` r
GetGHAPRNumber(lGHEventPayload = LoadGHEventPayload())
```

## Arguments

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/reference/LoadGHEventPayload.md).

## Value

An integer pull request number, or `NULL` if the GitHub Actions event
payload does not include a pull request number (for example, when the
workflow was not triggered by a pull_request event or no `inputs.pr`
value was provided).
