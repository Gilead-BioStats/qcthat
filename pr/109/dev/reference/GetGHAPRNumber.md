# Get the PR number for a GitHub Action

Get the PR number for a GitHub Action

## Usage

``` r
GetGHAPRNumber()
```

## Value

An integer pull request number, or `NULL` if not running in a
PR-triggered action (as indicated by the environment variables
`"GITHUB_EVENT_NAME"` and `"GITHUB_REF_NAME"`).
