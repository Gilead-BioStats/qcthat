# Find the root of the package repo

Find the root of the package repo

## Usage

``` r
GetPkgRoot(strPkgRoot, envCall = rlang::caller_env())
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The path to the root of the package.
