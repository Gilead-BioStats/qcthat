# Build an O(1) lookup for commit positions in a log

Build an O(1) lookup for commit positions in a log

## Usage

``` r
BuildCommitIndexEnv(chrCommits)
```

## Arguments

- chrCommits:

  (`character`) An ordered vector of commit SHAs (most recent first, as
  returned by
  [`gert::git_log()`](https://docs.ropensci.org/gert/reference/git_commit.html)).

## Value

An environment mapping each SHA to its 1-based position index.
