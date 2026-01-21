# Fetch workflow runs for a PR

Fetch workflow runs for a PR

## Usage

``` r
FetchPRActionRuns(
  intPRNumber,
  strPRHeadRef,
  strAction = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

- strPRHeadRef:

  (`length-1 character`) The branch name (head ref) of the PR.

- strAction:

  (`length-1 character`) Optional string to filter workflow paths (e.g.,
  "qcthat-pr_issues").

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A list of workflow run objects returned by
[`CallGHAPI()`](https://gilead-biostats.github.io/qcthat/dev/reference/CallGHAPI.md).
