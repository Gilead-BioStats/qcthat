# Guess the most relevant pull request number

Tries to find a pull request associated with the active branch.

## Usage

``` r
GuessPRNumber(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The associated pull request number as an integer, or `NULL` if no pull
requests are found.

## Examples

``` r
if (FALSE) { # interactive()

  GuessPRNumber()
}
```
