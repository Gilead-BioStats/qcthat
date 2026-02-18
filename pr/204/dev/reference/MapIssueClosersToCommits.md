# Add Commits list column to dfIssueClosers

Add Commits list column to dfIssueClosers

## Usage

``` r
MapIssueClosersToCommits(
  dfIssueClosers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  lPRs = NULL
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

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

- lPRs:

  (`list` or `NULL`) Optional list of raw pull request objects as
  returned by
  [`FetchRawRepoPRs()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRawRepoPRs.md).
  If provided, PRs will be looked up from this list instead of fetching
  individually from the API.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Issue`: Issue number (integer).

- `Commits`: List column containing character vectors of commit SHAs
  associated with each issue.
