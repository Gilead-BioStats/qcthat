# Fetch the URL for a GitHub Actions run

Fetch the URL for a GitHub Actions run

## Usage

``` r
FetchRunURL(
  strRunID = character(),
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

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A string containing the URL for the specified GitHub Actions run,
linking to the specific job when there is only one job.
