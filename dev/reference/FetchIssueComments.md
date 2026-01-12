# Fetch comments on an issue

Fetch comments on an issue

## Usage

``` r
FetchIssueComments(
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

A `qcthat_Comments` object, which is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Body`: Comment body (the full text of the comment).

- `Url`: URL of the comment on GitHub.

- `CommentGHID`: GitHub ID of the comment.

- `Author`: GitHub username of the comment author.

- `CreatedAt`: `POSIXct` timestamp of when the issue was created.

- `UpdatedAt`: `POSIXct` timestamp of when the issue was last updated.

- `qcthatCommentID`: The `qcthat-comment-id`, which is usually a hash of
  the title of the comment (when present).
