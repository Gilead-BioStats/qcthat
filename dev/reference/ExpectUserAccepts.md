# Does a user accept the feature?

**\[experimental\]**

Create a GitHub sub-issue assigned to a human reviewer to track user
acceptance that the work described in a parent issue is complete. Use
this inside a
[`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html)
block to extend test coverage to changes that require human judgment,
such as aesthetic or layout changes to a report.

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

The input `strDescription`, invisibly.

## Details

When called outside of CRAN, inside a git repository, and with an
internet connection, `ExpectUserAccepts()` performs the following steps:

1.  Looks for an existing child issue of `intIssue` labeled
    `"qcthat-uat"` whose title matches `strDescription`.

2.  If no such issue exists, creates one as a sub-issue with the title
    `"qcthat Acceptance for #N: {strDescription}"`, a body containing
    `chrInstructions` and checkbox items from `chrChecks`, and the
    `"qcthat-uat"` label.

3.  Assigns the issue to `chrAssignees` (re-opening it if it was closed
    and a new assignee is added).

4.  Checks the issue state:

    - **Closed**: calls
      [`testthat::pass()`](https://testthat.r-lib.org/reference/fail.html).

    - **Open**: calls
      [`testthat::fail()`](https://testthat.r-lib.org/reference/fail.html)
      only when `lglReportFailure` is `TRUE` (controlled by the
      `qcthat_UAT` environment variable via
      [`IsCheckingUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/IsCheckingUAT.md)).

5.  Logs the result for use in UAT reports (see
    [`CommentUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentUAT.md)).

When any guard condition is not met (on CRAN, not a git repo, or
offline), the function silently returns `strDescription` without side
effects.

## See also

- [`vignette("expect_user_accepts")`](https://gilead-biostats.github.io/qcthat/dev/articles/expect_user_accepts.md)
  for a full walk-through of the UAT system.

Other UAT functions:
[`CommentUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentUAT.md),
[`IsCheckingUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/IsCheckingUAT.md),
[`TriggerUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/TriggerUAT.md)

## Examples

``` r
if (FALSE) { # \dontrun{
test_that("report uses updated brand colors (#42)", {
  ExpectUserAccepts(
    strDescription = "Report header uses updated brand colors",
    intIssue = 42L,
    chrChecks = c(
      "Header background is #59488f",
      "Logo is centered and not clipped"
    ),
    chrAssignees = "design-reviewer"
  )
})
} # }
```
