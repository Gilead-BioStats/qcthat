# Assign a GitHub issue to one or more users

Update the assignee list for a GitHub issue. If any members of
`chrAssignees` are not already assigned to the issue, they will be added
as assignees, and the issue will be opened if `lglOpenOnAssign` is
`TRUE`.

## Usage

``` r
AssignIssue(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfIssue:

  (`data.frame`, `numeric`, `gh_response`, or other) The issue to
  assign, as returned by
  [`FetchIssueDetails()`](https://gilead-biostats.github.io/qcthat/reference/FetchIssueDetails.md),
  or something that can be coerced to such a `data.frame`.

- chrAssignees:

  (`character`) GitHub usernames to whom the issue should be assigned
  (in addition to any current assignees). Elements will be split on
  commas, so a single string can be read from an environment variable
  and passed here.

- lglOpenOnAssign:

  (`length-1 logical`) Whether to open the issue if it is currently
  closed and at least one assignee is new.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A `qcthat_Issues` object, which is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Issue`: Issue number.

- `Title`: Issue title.

- `Body`: Issue body (the full text of the issue).

- `Labels`: List column of character vectors of issue labels.

- `State`: Issue state (`open` or `closed`).

- `StateReason`: Reason for issue state (e.g., `completed`) or `NA` if
  not applicable.

- `Milestone`: Issue milestone title or `NA` if not applicable.

- `Type`: Issue type or `"Issue"` if no issue type is available.

- `Url`: URL of the issue on GitHub.

- `ParentOwner`: GitHub username or organization name of the parent
  issue if applicable, otherwise `NA`.

- `ParentRepo`: GitHub repository name of the parent issue if
  applicable, otherwise `NA`.

- `ParentNumber`: GitHub issue number of the parent issue if applicable,
  otherwise `NA`.

- `CreatedAt`: `POSIXct` timestamp of when the issue was created.

- `ClosedAt`: `POSIXct` timestamp of when the issue was closed, or `NA`
  if the issue is still open.

- `Assignees`: List column of character vectors of GitHub usernames of
  issue assignees.
