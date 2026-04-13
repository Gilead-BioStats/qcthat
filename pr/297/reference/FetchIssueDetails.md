# Fetch issue details from GitHub

Fetch issue details from GitHub

## Usage

``` r
FetchIssueDetails(
  intIssues,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssues:

  (`integer`) A vector of issue numbers from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/CompileIssueTestMatrix.md)
  matrix or from GitHub.

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
with columns:

- `Issue`: Issue number.

- `Title`: Issue title.

- `Body`: Issue body (or `NA_character_` if NULL).
