# Create a child issue linked to a parent issue

Create a child issue linked to a parent issue

## Usage

``` r
CreateChildIssue(
  intParentIssue,
  strTitle,
  strBody,
  ...,
  chrLabels = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intParentIssue:

  (`length-1 integer`) The number of an issue to which a child issue
  will attach.

- strTitle:

  (`length-1 character`) A title for an issue.

- strBody:

  (`length-1 character`) The body of an issue, PR, or comment, in GitHub
  markdown.

- ...:

  Additional parameters passed to
  [`CreateRepoIssueRaw()`](https://gilead-biostats.github.io/qcthat/dev/reference/CreateRepoIssueRaw.md).

- chrLabels:

  (`character`) The name(s) of labels(s) to use.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A tibble with one row representing the created child issue.
