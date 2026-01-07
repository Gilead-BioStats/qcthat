# Comment on a GitHub issue

Comment on a GitHub issue

## Usage

``` r
CommentIssueRaw(
  intIssue,
  strBodyCompiled,
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

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The comment object as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html), invisibly.
