# Load the package environment for coverage tracing

Thin wrapper around
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
so it can be mocked in tests.

## Usage

``` r
LoadPkgEnv(strTestDir, envCall = rlang::caller_env())
```

## Arguments

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The loaded package environment.
