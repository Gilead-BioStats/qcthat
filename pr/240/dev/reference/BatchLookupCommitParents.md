# Look up parent SHAs for multiple commits using git2r

Uses
[`git2r::lookup()`](https://docs.ropensci.org/git2r/reference/lookup.html)
and
[`git2r::parents()`](https://docs.ropensci.org/git2r/reference/parents.html)
to efficiently retrieve parent SHAs for many commits in a single
repository session. This is much faster than calling
[`gert::git_commit_info()`](https://docs.ropensci.org/gert/reference/git_commit.html)
per commit for large repositories.

## Usage

``` r
BatchLookupCommitParents(chrSHAs, strPkgRoot = ".")
```

## Arguments

- chrSHAs:

  (`character`) A vector of commit SHAs.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

A list of character vectors, one per element of `chrSHAs`, each
containing the parent SHAs for that commit, or `character(0)` if the
commit is not available locally.

## Details

If a SHA is not found locally (e.g., a squash-merge commit that GitHub
records but never existed in the local history), `character(0)` is
returned for that element.
