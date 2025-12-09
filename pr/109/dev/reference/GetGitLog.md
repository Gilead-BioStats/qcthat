# List commits in a git reference

List commits in a git reference

## Usage

``` r
GetGitLog(strGitRef, strPkgRoot = ".", intMaxCommits = 1e+05)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

## Value

A data frame of commits that are in `strGitRef`, as returned by
[`gert::git_log()`](https://docs.ropensci.org/gert/reference/git_commit.html).
