# Extract issue numbers from a PR's UAT comment

Extract issue numbers from a PR's UAT comment

## Usage

``` r
FetchPRUATCommentIssues(
  intPRNumber,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A sorted integer vector of unique issue numbers found in the UAT
comment. Returns `NULL` invisibly if no comment or no issues are found.
