# Git blame a file (raw)

Git blame a file (raw)

## Usage

``` r
BlameFileRaw(strFilePath, envCall = rlang::caller_env())
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The result of
[`git2r::blame()`](https://docs.ropensci.org/git2r/reference/blame.html).
This function exists to make mocking easier.
