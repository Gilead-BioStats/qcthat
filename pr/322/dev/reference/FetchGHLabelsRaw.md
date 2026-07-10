# Fetch GitHub labels as raw list

Fetch GitHub labels as raw list

## Usage

``` r
FetchGHLabelsRaw(
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

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A list of label objects as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
