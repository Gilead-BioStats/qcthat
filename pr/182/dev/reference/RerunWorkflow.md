# Trigger a rerun of a GitHub Action workflow run

Trigger a rerun of a GitHub Action workflow run

## Usage

``` r
RerunWorkflow(
  strRunID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character, double, or integer`) The ID of the workflow run
  to rerun.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

An empty GitHub API return with status code 201.
