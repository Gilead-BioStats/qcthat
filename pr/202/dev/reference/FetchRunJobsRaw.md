# Fetch raw job info for a GitHub Actions run

Fetch raw job info for a GitHub Actions run

## Usage

``` r
FetchRunJobsRaw(
  strRunID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A list of raw job objects as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
