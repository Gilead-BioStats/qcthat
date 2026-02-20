# Rerun QCPR workflows for PRs if UAT conditions are met

Rerun QCPR workflows for PRs if UAT conditions are met

## Usage

``` r
MaybeRerunAllQCPRWorkflows(
  dfOpenPRRefs,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfOpenPRRefs:

  (`data.frame`) A tibble of PR references, as returned by
  [`FetchAllIssuePRRefs()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchAllIssuePRRefs.md).
  Must contain columns `PR`, `HeadRef`, and `SHA`.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

`dfOpenPRRefs` (invisibly). Called for side effects.
