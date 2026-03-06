# Comment on a PR or issue with a UAT report

**\[experimental\]**

Add or update a comment on a GitHub pull request (or issue) with a
report of issues that require user acceptance, formatted in GitHub
markdown. Note: This should only be called *after* the test suite has
ran.

## Usage

``` r
CommentUAT(
  intPRNumber = GuessPRNumber(strPkgRoot = strPkgRoot, strOwner = strOwner, strRepo =
    strRepo, strGHToken = strGHToken),
  lglUpdate = TRUE,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

- lglUpdate:

  (`length-1 logical`) Whether to update an existing comment or label if
  it already exists (rather than creating a new comment or label).

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

Invisibly returns the result of
[`CommentIssue()`](https://gilead-biostats.github.io/qcthat/reference/CommentIssue.md).
