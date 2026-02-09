# Add Commits list column to dfIssueClosers

Add Commits list column to dfIssueClosers

## Usage

``` r
MapIssueClosersToCommits(
  dfIssueClosers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfIssueClosers:

  (`data.frame`) The
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  returned by
  [`FetchRepoIssueClosers()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssueClosers.md).

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
