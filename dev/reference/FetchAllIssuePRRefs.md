# Fetch all PRs that reference a specific issue

Fetch all PRs that reference a specific issue

## Usage

``` r
FetchAllIssuePRRefs(
  intIssue,
  strPRState = c("open", "closed", "merged"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- strPRState:

  (`character`) States to include in the fetch. Valid values are
  `"open"`, `"closed"`, and `"merged"`. By default all states are
  allowed.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A tibble containing PR details (PR number, State, HeadRef, SHA).
