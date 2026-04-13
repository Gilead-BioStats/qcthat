# Map tests to potential issues via commit joins

Map tests to potential issues via commit joins

## Usage

``` r
MapTestsToPotentialIssues(
  dfTestCommitsLong,
  dfIssueCommitsLong = NULL,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfTestCommitsLong:

  A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with one row per test-commit pair, typically from
  [`ExtractLongTestCommits()`](https://gilead-biostats.github.io/qcthat/reference/ExtractLongTestCommits.md).

- dfIssueCommitsLong:

  (`data.frame` or `NULL`) Pre-computed issue-commit mappings from
  [`MapLongIssueCommits()`](https://gilead-biostats.github.io/qcthat/reference/MapLongIssueCommits.md).
  If `NULL` (the default), fetched automatically from the GitHub API.
  Provide this when calling
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md)
  multiple times to avoid redundant API requests.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
in long format with columns `Test`, `File`, `Issues`, and `Issue` (the
potential issue number).
