# Fetch all issue numbers associated with a merge

Fetch all issue numbers associated with a merge

## Usage

``` r
FetchAllMergeIssueNumbers(
  intPRNumbers,
  chrCommitSHAs,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumbers:

  (`integer`) A vector of pull request numbers.

- chrCommitSHAs:

  (`character`) SHAs of git commits.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A sorted, unique integer vector of associated issue numbers.
