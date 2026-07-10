# Fetch commit SHAs for a batch of PRs in one GraphQL query

Fetch commit SHAs for a batch of PRs in one GraphQL query

## Usage

``` r
FetchPRCommitSHAsBatch(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumbers:

  (`integer`) A batch of PR numbers to query together.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A list of character vectors, one per element of `intPRNumbers`.
