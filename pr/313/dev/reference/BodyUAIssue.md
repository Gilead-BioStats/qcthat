# Generate a body for a UAT issue

Generate a body for a UAT issue

## Usage

``` r
BodyUAIssue(chrChecks = character(), chrInstructions = character())
```

## Arguments

- chrChecks:

  (`character`) Items for the user to check. These will be preceded by
  checkboxes in the associated issue.

- chrInstructions:

  (`character`) Instructions for how to review an issue. Included in the
  associated issue before the checklist.

## Value

A string body for the UAT issue.
