# Does a user accept the feature?

Create and track a sub-issue to track user acceptance that an issue is
complete.

## Usage

``` r
ExpectUserAccepts(
  strDescription,
  intIssue,
  chrInstructions = character(),
  chrChecks = character(),
  lglReportFailure = IsCheckingUAT(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strDescription:

  (`length-1 character`) A brief description of a user expectation.

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- chrInstructions:

  (`character`) Instructions for how to review an issue. Included in the
  associated issue before the checklist.

- chrChecks:

  (`character`) Items for the user to check. These will be preceded by
  checkboxes in the associated issue.

- lglReportFailure:

  (`length-1 logical`) Whether to ignore failures (default unless a
  "qcthat_UAT" environment variable is "true"), or fail (and show as a
  failure in testthat tests).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The input `chrChecks`, invisibly.
