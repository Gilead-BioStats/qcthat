# Map tests to covered source lines

Map tests to covered source lines

## Usage

``` r
MapTestsToCoveredLines(
  envPkg,
  dfFileTests = NULL,
  strTestDir = "tests/testthat",
  envCall = rlang::caller_env()
)
```

## Arguments

- envPkg:

  (`environment`) A loaded package environment, as returned by
  [`LoadPkgEnv()`](https://gilead-biostats.github.io/qcthat/reference/LoadPkgEnv.md).

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/reference/ExtractTestsFromFiles.md).

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with one row per (test, source line) pair:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the test file, relative to the package root.

- `LineStart`: Starting line number of the test.

- `LineEnd`: Ending line number of the test.

- `Issues`: List column of integer vectors of already-tagged issue
  numbers.

- `SourceFile`: Path to the R source file, relative to the package root.

- `Line`: Line number in `SourceFile` exercised by this test.
