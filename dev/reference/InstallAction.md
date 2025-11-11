# Install an action from qcthat into a package repo

Install an action from qcthat into a package repo

## Usage

``` r
InstallAction(
  strActionName,
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
)
```

## Arguments

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The path to the created GitHub Action YAML file (invisibly).
