# Construct the URL for a GitHub Actions job

Construct the URL for a GitHub Actions job

## Usage

``` r
ConstructJobURL(
  strRunID = character(),
  strJobID = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo()
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

## Value

A string containing the URL for the specified GitHub Actions job.
