# Construct the URL for the session info step of a GitHub Actions job

Construct the URL for the session info step of a GitHub Actions job

## Usage

``` r
LinkSessionInfo(
  strRunID = character(),
  strJobID = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strJobID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run job.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A string containing the URL for the session info step (if any) in the
specified GitHub Actions job.
