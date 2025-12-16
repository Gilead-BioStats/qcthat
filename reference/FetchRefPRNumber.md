# Fetch the pull request number for a branch or other git ref

Fetch the pull request number for a branch or other git ref

## Usage

``` r
FetchRefPRNumber(
  strSourceRef = GetActiveBranch(),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

An integer pull request number, or `integer(0)` if no matching PR (or
more than one matching PR) is found.

## Examples

``` r
if (FALSE) { # interactive()

  FetchRefPRNumber()
}
```
