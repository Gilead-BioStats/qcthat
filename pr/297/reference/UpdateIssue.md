# Update a GitHub issue

Update one or more fields in a GitHub issue. `NULL` values are ignored,
while empty values (such as
[`character()`](https://rdrr.io/r/base/character.html)) often result in
clearing the field. See the [GitHub API
documentation](https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#update-an-issue)
for more details.

## Usage

``` r
UpdateIssue(
  intIssue,
  ...,
  strTitle = NULL,
  strBody = NULL,
  strState = NULL,
  strStateReason = NULL,
  strMilestone = NULL,
  chrLabels = NULL,
  chrAssignees = NULL,
  strType = NULL,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intIssue:

  (`length-1 integer`) The issue to update.

- ...:

  Additional arguments to pass to
  [`CallGHAPI()`](https://gilead-biostats.github.io/qcthat/reference/CallGHAPI.md).
  Any `NULL` values are discarded.

- strTitle:

  (`length-1 character`) A title for an issue.

- strBody:

  (`length-1 character`) The body of an issue, PR, comment, or release,
  in GitHub markdown.

- strState:

  (`length-1 integer`) The state to set. Must be one of `"open"`,
  `"closed"`, or `NULL` (to ignore this field).

- strStateReason:

  (`length-1 character`) The reason for the state change (for `"closed"`
  `strState`). Must be one of `"completed"`, `"not_planned"`,
  `"duplicate"`, `"reopened."`, or `NULL`.

- strMilestone:

  (`length-1 character`) The milestone to set. Must be the title of an
  existing milestone, `NULL` (to ignore this field), or
  [`character()`](https://rdrr.io/r/base/character.html) to remove the
  milestone.

- chrLabels:

  (`character`) The name(s) of labels(s) to use.

- chrAssignees:

  (`character`) The assignees to set. Must be the logins of existing
  users, `NULL` (to ignore this field), or
  [`character()`](https://rdrr.io/r/base/character.html) to remove all
  assignees.

- strType:

  (`length-1 character`) The type of issue to set. Must be the name of
  an issue type available to this repo, or `NULL` (to ignore this
  field).

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
