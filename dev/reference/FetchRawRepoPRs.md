# Fetch repo PRs from GitHub

Fetch repo PRs from GitHub

## Usage

``` r
FetchRawRepoPRs(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strState:

  (`length-1 character`) State of issues or pull requests to fetch. Must
  be one of `"open"`, `"closed"`, or `"all"`. Defaults to `"open"` for
  pull requests and `"all"` for issues.

## Value

A list of raw pull request objects as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
