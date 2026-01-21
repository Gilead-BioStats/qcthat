# Rerun a workflow only if no instances are currently in progress

Rerun a workflow only if no instances are currently in progress

## Usage

``` r
RerunWorkflowIfFinished(
  lPRActionRuns,
  strCommitSHA,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- lPRActionRuns:

  (`list`) A list of workflow run objects as returned by GitHub.

- strCommitSHA:

  (`length-1 character`) The commit SHA to target.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

`NULL` (invisibly). Called for side effects.
