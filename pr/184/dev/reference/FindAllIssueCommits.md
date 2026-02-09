# Add Commits list column to dfIssueClosers

Add Commits list column to dfIssueClosers

## Usage

``` r
FindAllIssueCommits(
  strCloserType,
  strCloserSHA,
  intCloserPRNumber,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strCloserType:

  (`length-1 character`) Whether the issue was closed by a
  `"PullRequest"` or a `"Commit"`.

- strCloserSHA:

  (`length-1 character`) The commit SHA for an issue closed by a
  `"Commit"`.

- intCloserPRNumber:

  (`length-1 integer`) The number of the pull request that closed the
  issue.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A character vector of commit SHAs associated with this issue.
