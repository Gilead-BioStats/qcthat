# Get rid of PRs in the issues list

Get rid of PRs in the issues list

## Usage

``` r
CompileIssuesDF(lIssuesNonPR)
```

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
