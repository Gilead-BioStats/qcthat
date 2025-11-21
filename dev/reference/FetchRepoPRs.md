# Fetch repository pull requests

Download pull requests in a repository and parse them into a tidy
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Usage

``` r
FetchRepoPRs(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strState:

  (`length-1 character`) State of issues or pull requests to fetch. Must
  be one of `"open"`, `"closed"`, or `"all"`. Defaults to `"open"` for
  pull requests and `"all"` for issues.

## Value

A `qcthat_PRs` object, which is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `PR`: Pull request number.

- `Title`: Pull request title.

- `State`: Pull request state (`"open"` or `"closed"`).

- `HeadRef`: The head reference (branch) of the pull request (the
  changes).

- `BaseRef`: The base reference (branch) of the pull request (the
  target).

- `Body`: The full text of the pull request.

- `MergeCommitSHA`: The SHA of the merge commit, if the pull request has
  been merged.

- `IsDraft`: Logical indicating whether the pull request is a draft.

- `Url`: URL of the pull request on GitHub.

- `CreatedAt`: `POSIXct` timestamp of when the pull request was created.

- `ClosedAt`: `POSIXct` timestamp of when the pull request was closed,
  or `NA` if the pull request is still open.

- `MergedAt`: `POSIXct` timestamp of when the pull request was merged,
  or `NA` if the pull request has not been merged.

## Examples

``` r
if (FALSE) { # interactive()

  FetchRepoPRs()
}
```
