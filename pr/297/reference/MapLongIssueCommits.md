# Map issues to commits in long format

**\[experimental\]**

Fetches all closed issues for a repository and maps each to the commits
that closed it, returning one row per issue-commit pair. This is an
optional input to
[`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md).
Pre-computing it once and passing the result via `dfIssueCommitsLong`
avoids redundant API calls when processing multiple test files.

## Usage

``` r
MapLongIssueCommits(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
)
```

## Arguments

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
with one row per issue-commit pair, containing columns `Issue` and
`Commits`.

## Examples

``` r
if (FALSE) { # interactive()

  dfIssueCommitsLong <- MapLongIssueCommits()
}
```
