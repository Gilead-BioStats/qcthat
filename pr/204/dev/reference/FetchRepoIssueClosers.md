# Fetch repository issue closers

Fetch the closers (commits or pull requests) for all closed issues in a
repository.

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

- `CloserSHA`: SHA of the commit that closed the issue, or `NA` if the
  issue was closed by a pull request.

- `CloserPRNumber`: Number of the pull request that closed the issue, or
  `NA` if the issue was closed by a commit.

## Examples

``` r
if (FALSE) { # interactive()

  FetchRepoIssueClosers()
}
```
