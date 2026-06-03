# Update an issue through the GitHub API

Update an issue through the GitHub API

## Usage

``` r
UpdateIssueRaw(
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

A list with a raw issue object as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
