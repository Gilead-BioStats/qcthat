# Fetch a single page of commits from a comparison

Fetch a single page of commits from a comparison

## Usage

``` r
FetchMergeCommitBatchRaw(
  strSourceRef,
  strTargetRef,
  intPage = 1,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

- strTargetRef:

  (`length-1 character`) Name of the git reference that will be merged
  into. Defaults to the default branch of this repository.

- intPage:

  (`length-1 integer`) The page number to fetch.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A raw list response from the API.
