# Fetch a batch of raw repository issue closers

Fetch a batch of raw repository issue closers

## Usage

``` r
FetchRepoIssueClosersRawBatch(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strCursor = NULL
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strCursor:

  (`character(1)`\|`NULL`) The cursor to start fetching from.

## Value

A list of raw issue closer objects as returned by
[`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html).
