# Fetch the pull request number for a branch or other git ref

Fetch the pull request number for a branch or other git ref

## Usage

``` r
FetchRefPRNumber(
  strSourceRef = GetActiveBranch(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
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

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

An integer pull request number, or
[`integer()`](https://rdrr.io/r/base/integer.html) if no matching PR is
found. If multiple PRs are found, first, if there are any open PRs, we
filter to only include open PRs, then the PR that was most recently
created is returned.

## Examples

``` r
if (FALSE) { # interactive()

  FetchRefPRNumber()
}
```
