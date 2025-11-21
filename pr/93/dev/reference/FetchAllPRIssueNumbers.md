# Fetch all issue numbers associated with a vector of PRs

Fetch all issue numbers associated with a vector of PRs

Fetch all issue numbers associated with a vector of PRs

## Usage

``` r
FetchAllPRIssueNumbers(
  intPRNumbers,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)

FetchAllPRIssueNumbers(
  intPRNumbers,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
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

A sorted, unique integer vector of associated issue numbers.

A sorted, unique integer vector of associated issue numbers.
