# Update a GitHub issue (implementation)

Update a GitHub issue (implementation)

## Usage

``` r
AssignIssueImpl(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
)
```

## Arguments

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

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

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
