# Comment on a GitHub Issue

Create or update a comment on a GitHub issue with a standardized format.

## Usage

``` r
CommentIssue(
  intIssue,
  strTitle,
  strBody,
  strCommentID = rlang::hash(strTitle),
  lglUpdate = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- strTitle:

  (`length-1 character`) A title for an issue.

- strBody:

  (`length-1 character`) The body of an issue, PR, or comment, in GitHub
  markdown.

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

## Examples

``` r
if (FALSE) { # interactive()
# This only works if you have an issue #1 in your repository.
CommentIssue(
  intIssue = 1,
  strTitle = "QC Report",
  strBody = "All checks passed successfully."
)
}
```
