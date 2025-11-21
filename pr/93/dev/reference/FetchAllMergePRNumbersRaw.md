# Fetch associated PR data for commits via GraphQL

Fetch associated PR data for commits via GraphQL

## Usage

``` r
FetchAllMergePRNumbersRaw(
  chrCommitSHAs,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- chrCommitSHAs:

  (`character`) SHAs of git commits.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A raw list response from the
[`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html) call.
