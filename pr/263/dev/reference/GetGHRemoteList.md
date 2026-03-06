# Wrapper around gert::git_remote_list() for mocking

Wrapper around gert::git_remote_list() for mocking

## Usage

``` r
GetGHRemoteList(strPkgRoot)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

The result of the
[`gert::git_remote_list()`](https://docs.ropensci.org/gert/reference/git_remote.html)
call.
