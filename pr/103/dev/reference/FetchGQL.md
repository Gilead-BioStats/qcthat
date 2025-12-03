# Wrapper for GitHub GraphQL API calls

Wrapper for GitHub GraphQL API calls

## Usage

``` r
FetchGQL(
  strQuery,
  ...,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strQuery:

  (`length-1 character`) The GraphQL query (or sub-query).

- ...:

  Additional parameters passed to
  [`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The result of the
[`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html) call.
