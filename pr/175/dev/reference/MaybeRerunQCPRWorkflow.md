# Rerun the QCPR workflow for a specific PR and commit

Rerun the QCPR workflow for a specific PR and commit

## Usage

``` r
MaybeRerunQCPRWorkflow(
  intPRNumber,
  strPRHeadRef,
  strCommitSHA,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

- strPRHeadRef:

  (`length-1 character`) The branch name (head ref) of the PR.

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
