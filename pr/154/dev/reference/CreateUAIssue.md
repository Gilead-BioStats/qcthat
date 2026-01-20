# Create a user-acceptance sub-issue for an issue

Create a user-acceptance sub-issue for an issue

## Usage

``` r
CreateUAIssue(
  strDescription,
  intIssue,
  chrChecks = character(),
  chrInstructions = character(),
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

- chrChecks:

  (`character`) Items for the user to check. These will be preceded by
  checkboxes in the associated issue.

- chrInstructions:

  (`character`) Instructions for how to review an issue. Included in the
  associated issue before the checklist.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A data frame representing the created user-acceptance issue.
