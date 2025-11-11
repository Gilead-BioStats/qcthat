# Fetch repository issues

Download (non-pull-request) issues in a repository and parse them into a
tidy
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Usage

``` r
FetchRepoIssues(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

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

## Examples

``` r
if (FALSE) { # interactive()

  FetchRepoIssues()
}
```
