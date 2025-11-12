# Guess the most relevant pull request number

Tries to find a pull request associated with the active branch. If it
fails, it falls back to finding the latest pull request number,
optionally filtered by state.

## Usage

``` r
GuessPRNumber(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The latest pull request number as an integer, or `integer(0)` if no pull
requests are found.

## Examples

``` r
if (FALSE) { # interactive()

  GuessPRNumber()
}
```
