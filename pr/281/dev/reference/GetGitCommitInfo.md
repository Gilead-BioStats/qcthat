# Wrapper around gert::git_commit_info() for mocking

Wrapper around gert::git_commit_info() for mocking

## Usage

``` r
GetGitCommitInfo(strRef, strPkgRoot = ".")
```

## Arguments

- strRef:

  (`length-1 character`) A branch, tag, or commit SHA.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

The result of
[`gert::git_commit_info()`](https://docs.ropensci.org/gert/reference/git_commit.html).
