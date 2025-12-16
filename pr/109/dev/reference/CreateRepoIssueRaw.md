# Create an issue in a repository

Create an issue in a repository

## Usage

``` r
CreateRepoIssueRaw(
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

- strTitle:

  (`length-1 character`) A title for an issue.

- strBody:

  (`length-1 character`) The body of an issue, in GitHub markdown.

- ...:

  Additional parameters passed to
  [`CallGHAPI()`](https://gilead-biostats.github.io/qcthat/dev/reference/CallGHAPI.md).

- chrLabels:

  (`character`) The name(s) of labels(s) to use.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A list representing the issue, as returned by GitHub.
