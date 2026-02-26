# Fetch repository issue closers

Fetch the closers (commits or pull requests) for all closed issues in a
repository. In addition to formal `ClosedEvent`s (where a commit or
merged PR directly closed the issue), this also includes
`ConnectedEvent`s (where a merged PR was manually linked to the issue)
that have not been subsequently cancelled by a `DisconnectedEvent`. An
issue may appear more than once if it has multiple valid closers.

## Usage

``` r
FetchRepoIssueClosers(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Issue`: Issue number.

- `CloserType`: Type of the closer, either `Commit` or `PullRequest`.

- `CloserSHA`: SHA of the commit that closed the issue. For `Commit`
  closers, this is the commit OID directly. For `PullRequest` closers,
  this is the merge commit SHA.

- `CloserPRNumber`: Number of the pull request that closed the issue, or
  `NA` if the issue was closed by a commit.

- `CloserDate`: Timestamp of the closing event as a character string.

## Examples

``` r
if (FALSE) { # interactive()

  FetchRepoIssueClosers()
}
```
