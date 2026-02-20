# Fetch commit SHAs for multiple merged PRs using a single local git log

Fetches the full repository log once and resolves all PR commit sets in
R, replacing the per-PR calls to
[`GetGitAheadBehind()`](https://gilead-biostats.github.io/qcthat/dev/reference/GetGitAheadBehind.md)
and
[`GetGitLog()`](https://gilead-biostats.github.io/qcthat/dev/reference/GetGitLog.md).
Parent SHAs are retrieved in batch via
[`BatchLookupCommitParents()`](https://gilead-biostats.github.io/qcthat/dev/reference/BatchLookupCommitParents.md)
(using `git2r`), which is much faster than per-commit
[`gert::git_commit_info()`](https://docs.ropensci.org/gert/reference/git_commit.html)
calls in large repositories.

## Usage

``` r
FetchAllMergeCommitSHAsLocal(
  chrMergeSHAs,
  strPkgRoot = ".",
  intMaxCommits = 100000L
)
```

## Arguments

- chrMergeSHAs:

  (`character`) A vector of merge commit SHAs.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- intMaxCommits:

  (`length-1 integer`) Maximum number of commits to fetch from the log.
  Increase if the repository history exceeds this number.

## Value

A named list, one element per element of `chrMergeSHAs`, each a
character vector of commit SHAs introduced by that PR.
