# Find the owner of the target repository

A wrapper to safely call
[`gh::gh_tree_remote()`](https://gh.r-lib.org/reference/gh_tree_remote.html)
and extract the owner (`"username"`).

## Usage

``` r
GetGHOwner(strPkgRoot = ".")
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

A length-1 `character` vector representing the GitHub owner of the
repository at `strPkgRoot`.

## Examples

``` r
if (FALSE) { # interactive()
  GetGHOwner()
}
```
