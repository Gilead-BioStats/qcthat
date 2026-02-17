# Fetch a release from GitHub

Fetch a release from GitHub

## Usage

``` r
FetchRawReleaseByTagName(
  strTagName,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strTagName:

  (`length-1 character`) Name of the GitHub tag.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A raw release object as a list as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
