# Wrapper around gert::git_ahead_behind() for mocking

Wrapper around gert::git_ahead_behind() for mocking

## Usage

``` r
GetGitAheadBehind(strUpstream, strRef, strPkgRoot = ".")
```

## Arguments

- strUpstream:

  (`length-1 character`) The upstream branch or commit SHA.

- strRef:

  (`length-1 character`) The local branch or commit SHA.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

The result of
[`gert::git_ahead_behind()`](https://docs.ropensci.org/gert/reference/git_rebase.html).
