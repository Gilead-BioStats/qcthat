# Fetch all repo issues from GitHub

Fetch all repo issues from GitHub

## Usage

``` r
FetchRawRepoIssues(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A list of raw issue objects as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
