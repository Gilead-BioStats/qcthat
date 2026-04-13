# Run coverage for a single test block

Run coverage for a single test block

## Usage

``` r
CoverSingleTest(
  envPkg,
  strTempFile,
  strPkgRoot,
  strTestFile,
  strTempSnapDir,
  strAbsTestDir
)
```

## Arguments

- envPkg:

  (`environment`) Loaded package environment.

- strTempFile:

  (`length-1 character`) Path to the already-written temporary test
  file.

- strPkgRoot:

  (`length-1 character`) Path to the package root.

- strTestFile:

  (`length-1 character`) Original test file path (used for snapshot
  directory resolution).

- strTempSnapDir:

  (`length-1 character`) Path to the already-prepared temp snapshot
  directory.

- strAbsTestDir:

  (`length-1 character`) Absolute path to the test directory, passed to
  [`testthat::local_test_directory()`](https://testthat.r-lib.org/reference/local_test_directory.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with `SourceFile` (package-relative) and `Line` columns for covered
lines, or `NULL` on failure.
