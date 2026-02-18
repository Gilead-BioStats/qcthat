# Find the path to a file

Find the path to a file

## Usage

``` r
GetRelativePackagePath(strFilePath, envCall = rlang::caller_env())
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The path to a file, relative to the root of the package that the file is
within.
