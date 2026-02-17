# Compile release reports in GitHub markdown

Compile release reports in GitHub markdown

## Usage

``` r
CompileReleaseReportsMarkdown(
  chrBody,
  strRunID = NULL,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A single string containing the compiled markdown.
