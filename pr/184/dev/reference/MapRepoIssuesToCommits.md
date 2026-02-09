# Map repository issues to commits

Fetch all closed issues in a repository and expand their closers
(commits or pull requests) into the set of commits that might be related
to each issue.

## Usage

``` r
MapRepoIssuesToCommits(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
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

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Issue`: Issue number (integer).

- `Commits`: List column containing character vectors of commit SHAs
  associated with each issue.
