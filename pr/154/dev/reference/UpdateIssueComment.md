# Update or create a comment on a GitHub issue

Update or create a comment on a GitHub issue

## Usage

``` r
UpdateIssueComment(
  intIssue,
  strBodyCompiled,
  strCommentID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- strBodyCompiled:

  (`length-1 character`) The full body of an issue, PR, or comment, in
  GitHub markdown, including components such as a title and a hidden
  `qcthat-comment-id`.

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

The comment object as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html), invisibly.
