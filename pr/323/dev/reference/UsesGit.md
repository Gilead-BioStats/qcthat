# Check whether a package uses git

Check whether a package uses git

## Usage

``` r
UsesGit(strPkgRoot = ".")
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

A length-1 `logical` indicating whether the package at `strPkgRoot` is a
git repository.
