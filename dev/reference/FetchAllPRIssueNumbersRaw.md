# Fetch associated issue data for pull requests via GraphQL

Fetch associated issue data for pull requests via GraphQL

## Usage

``` r
FetchAllPRIssueNumbersRaw(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumbers:

  (`integer`) A vector of pull request numbers.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A raw list response from the
[`gh::gh_gql()`](https://gh.r-lib.org/reference/gh_gql.html) call.
