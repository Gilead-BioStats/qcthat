# Fetch commit SHAs from a comparison

Fetch commit SHAs from a comparison

## Usage

``` r
FetchMergeCommitSHAs(
  strSourceRef,
  strTargetRef,
  intPageMax = 100L,
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

- intPageMax:

  (`length-1 integer`) The maximum number of pages of commits to fetch
  from the GitHub API. Each page contains up to 100 commits. Defaults to
  100, which fetches up to 10,000 commits. You likely never need to
  increase this number, but try a larger number if a merge involves a
  very large number of commits in a very large repository.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

(`character`) A sorted, unique vector of commit SHAs.
