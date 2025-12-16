# Determine the active branch of a git repository

Determine the active branch of a git repository

## Usage

``` r
GetActiveBranch(strPkgRoot = ".")
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

A length-1 character vector representing the active branch name.
