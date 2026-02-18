# Fetch raw repository issue closers

Fetch raw repository issue closers

## Usage

``` r
FetchRepoIssueClosersRaw(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A list of raw issue closer objects as returned by
[`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html).
