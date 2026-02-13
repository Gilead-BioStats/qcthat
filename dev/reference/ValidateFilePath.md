# Validate and construct a file path

Validate and construct a file path

## Usage

``` r
ValidateFilePath(strFile, strDirPath, envCall = rlang::caller_env())
```

## Arguments

- strFile:

  (`length-1 character`) A file name without the path.

- strDirPath:

  (`length-1 character`) The path to a directory.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `character` path to the validated file.
