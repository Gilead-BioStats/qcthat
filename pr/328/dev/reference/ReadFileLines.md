# Read lines from a file

Read lines from a file

## Usage

``` r
ReadFileLines(
  strFile,
  strDirPath,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
)
```

## Arguments

- strFile:

  (`length-1 character`) A file name without the path.

- strDirPath:

  (`length-1 character`) The path to a directory.

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
