# Fetch the GitHub ID of an issue comment by its qcthat comment ID

Fetch the GitHub ID of an issue comment by its qcthat comment ID

## Usage

``` r
FetchIssueCommentGHID(
  intIssue,
  strCommentID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- strCommentID:

  (`length-1 character`) A unique ID for a comment within a given
  context, which is usually a hash of the title of the comment.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The GitHub ID of the comment.
