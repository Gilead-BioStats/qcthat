# Fetch existing GitHub label names

Fetch existing GitHub label names

## Usage

``` r
FetchGHLabelNames(
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

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A character vector of existing label names in the specified GitHub
repository.
