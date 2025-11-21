# Fetch commit SHAs from a comparison

Fetch commit SHAs from a comparison

Fetch commit SHAs from a comparison

## Usage

``` r
FetchMergeCommitSHAs(
  strSourceRef,
  strTargetRef,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)

FetchMergeCommitSHAs(
  strSourceRef,
  strTargetRef,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
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

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

(`character`) A sorted, unique vector of commit SHAs.

(`character`) A sorted, unique vector of commit SHAs.
