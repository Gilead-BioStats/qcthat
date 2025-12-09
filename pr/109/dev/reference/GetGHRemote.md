# Find the target repository

A wrapper to safely call
[`gh::gh_tree_remote()`](https://gh.r-lib.org/reference/gh_tree_remote.html)
if the project uses git.

## Usage

``` r
GetGHRemote(strPkgRoot = ".")
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

A list representing the GitHub repository at `strPkgRoot`.
