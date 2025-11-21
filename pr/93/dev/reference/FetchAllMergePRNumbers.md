# Fetch all PR numbers associated with a vector of commit SHAs

Fetch all PR numbers associated with a vector of commit SHAs

## Usage

``` r
FetchAllMergePRNumbers(
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

A sorted, unique integer vector of associated PR numbers.
