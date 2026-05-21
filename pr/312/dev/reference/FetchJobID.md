# Fetch the GitHub Actions job ID for a given run ID and job name

Fetch the GitHub Actions job ID for a given run ID and job name

## Usage

``` r
FetchJobID(
  strRunID = character(),
  strJobName = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strJobName:

  (`length-1 character`) Name of a GitHub Actions workflow job.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

The GitHub Actions job ID, or `NULL` if not found.
