# Fetch commit SHAs for multiple PRs using GitHub GraphQL API

Fetches all commits for each PR using batched GraphQL queries so that
the number of API calls scales with the number of PRs divided by the
batch size, not the number of PRs.

## Usage

``` r
FetchAllPRCommitSHAs(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumbers:

  (`integer`) A vector of PR numbers.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A list of character vectors, one per element of `intPRNumbers`, each
containing the commit SHAs for that PR.
