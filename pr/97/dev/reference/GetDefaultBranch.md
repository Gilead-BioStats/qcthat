# Determine the default branch of a git repository

Determine the default branch of a git repository

## Usage

``` r
GetDefaultBranch(strPkgRoot = ".")
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

## Value

A length-1 character vector representing the default branch name.
