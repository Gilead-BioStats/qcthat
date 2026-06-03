# Fetch the session info step number for a GitHub Actions job

Fetch the session info step number for a GitHub Actions job

## Usage

``` r
FetchSessionInfoStepNumber(
  strJobID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

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

The step number of the session info step, or `NULL` if not found.
