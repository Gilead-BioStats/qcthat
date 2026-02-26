# Tibblify a single issue closer

Tibblify a single issue closer

## Usage

``` r
TibblifyIssueCloser(lIssueCloser)
```

## Arguments

- lIssueCloser:

  (`list`) A single element of a raw issue closer object as returned by
  [`FetchRepoIssueClosersRaw()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssueClosersRaw.md).

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
