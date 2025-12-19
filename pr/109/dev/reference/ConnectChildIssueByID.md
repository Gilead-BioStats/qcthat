# Connect an issue to a parent issue

Connect an issue to a parent issue

## Usage

``` r
ConnectChildIssueByID(
  strChildIssueID,
  intParentIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strChildIssueID:

  (`length-1 character`) The `id` field of an issue to connect to a
  parent issue.

- intParentIssue:

  (`length-1 integer`) The number of the parent issue in a parent-child
  issue relationship.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The URL of the parent issue.
