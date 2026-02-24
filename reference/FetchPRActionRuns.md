# Fetch workflow runs for a PR

Fetch workflow runs for a PR

## Usage

``` r
FetchPRActionRuns(
  strPRHeadRef,
  strAction = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strPRHeadRef:

  (`length-1 character`) The branch name (head ref) of the PR.

- strAction:

  (`length-1 character`) Optional string to filter workflow paths (e.g.,
  "qcthat").

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A list of workflow run objects returned by
[`CallGHAPI()`](https://gilead-biostats.github.io/qcthat/reference/CallGHAPI.md).
