# Resolve the PR commits for a single merge commit

Uses a pre-fetched commit log and index to find all commits reachable
from the PR branch tip (parent2) but not from the target branch tip
(parent1), without making additional git calls.

## Usage

``` r
ResolvePRCommits(strMergeSHA, chrAllCommits, envCommitIndex, chrParents)
```

## Arguments

- strMergeSHA:

  (`length-1 character`) The merge commit SHA.

- chrAllCommits:

  (`character`) Full ordered commit log (most recent first) as returned
  by
  [`GetGitLog()`](https://gilead-biostats.github.io/qcthat/reference/GetGitLog.md).

- envCommitIndex:

  (`environment`) Named environment mapping SHAs to positions in
  `chrAllCommits`, as built by
  [`BuildCommitIndexEnv()`](https://gilead-biostats.github.io/qcthat/reference/BuildCommitIndexEnv.md).

- chrParents:

  (`character`) Parent SHAs of the merge commit, as returned by
  [`BatchLookupCommitParents()`](https://gilead-biostats.github.io/qcthat/reference/BatchLookupCommitParents.md).

## Value

A character vector of commit SHAs introduced by this PR.
