# Does a user accept the feature?

**\[experimental\]**

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
  chrAssignees = Sys.getenv("qcthat_UAT_ASSIGNEES"),
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

- chrAssignees:

  (`character`) GitHub usernames to which the issue associated with an
  expectation should be assigned. Whenever the issue is assigned to a
  new user, it will be re-opened. Elements of this vector will be split
  on commas, so you can provide multiple assignees in a single string.
  This is helpful if you would like to set up assignees via the
  `"qcthat_UAT_ASSIGNEES"` environment variable, which is checked by
  default.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

The input `chrChecks`, invisibly.
