# Map tests to potential issues via commit joins

Map tests to potential issues via commit joins

## Usage

``` r
MapTestsToPotentialIssues(
  dfTestCommitsLong,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfTestCommitsLong:

  A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with one row per test-commit pair, typically from
  [`ExtractLongTestCommits()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractLongTestCommits.md).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
in long format with columns `Test`, `File`, `Issues`, and `Issue` (the
potential issue number).
