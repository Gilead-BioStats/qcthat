# Fetch all user-acceptance sub-issues for an issue

Fetch all user-acceptance sub-issues for an issue

## Usage

``` r
FetchIssueUAChildren(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A data frame of user-acceptance sub-issues.
