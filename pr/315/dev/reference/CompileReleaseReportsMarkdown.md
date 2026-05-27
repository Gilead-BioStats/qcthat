# Compile release reports in GitHub markdown

Compile release reports in GitHub markdown

## Usage

``` r
CompileReleaseReportsMarkdown(
  chrBody,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strJobName = Sys.getenv("GITHUB_JOB"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strJobName:

  (`length-1 character`) Name of a GitHub Actions workflow job.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A single string containing the compiled markdown.
