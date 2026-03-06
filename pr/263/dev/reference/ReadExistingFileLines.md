# Read lines from an existing file

Read lines from an existing file

## Usage

``` r
ReadExistingFileLines(
  strFilePath,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
)
```

## Arguments

- strFilePath:

  (`length-1 character`) A file path.

- intLineStart:

  (`length-1 integer`) The starting line number.

- intLineEnd:

  (`length-1 integer`) The ending line number.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `character` vector containing a subset of lines from the file.
