# Read test code from a file

Read test code from a file

## Usage

``` r
ReadTestCode(
  strFile,
  intLineStart,
  intLineEnd,
  strTestDir = "tests/testthat",
  envCall = rlang::caller_env()
)
```

## Arguments

- strFile:

  (`length-1 character`) A file name without the path.

- intLineStart:

  (`length-1 integer`) The starting line number.

- intLineEnd:

  (`length-1 integer`) The ending line number.

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `character` vector containing a subset of lines from the file.
