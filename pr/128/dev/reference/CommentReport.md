# Comment on a PR or issue with a QC report

Add or update a comment on a GitHub pull request (or issue) with a QC
report, formatted in GitHub markdown.

## Usage

``` r
CommentReport(
  dfITM,
  strReportType,
  intPRNumber = GuessPRNumber(strOwner = strOwner, strRepo = strRepo, strGHToken =
    strGHToken),
  lglUpdate = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsIssueTestMatrix.md).

- strReportType:

  (`length-1 character`) The main title of the report, such as
  `"Completed Issues"` or `"PR-Associated Issues"`.

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

- lglUpdate:

  (`length-1 logical`) Whether to update an existing comment if it
  already exists (rather than creating a new comment).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

Invisibly returns the result of
[`CommentIssue()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentIssue.md).
