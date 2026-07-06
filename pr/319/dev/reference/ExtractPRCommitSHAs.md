# Extract commit SHAs from a PR node, handling pagination

Extract commit SHAs from a PR node, handling pagination

## Usage

``` r
ExtractPRCommitSHAs(
  lPRData,
  intPR,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- lPRData:

  (`list`) The `pullRequest` node from the GraphQL response.

- intPR:

  (`integer(1)`) PR number (used for follow-up pagination queries).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A character vector of commit SHAs.
