# Find test files

Find test files

## Usage

``` r
ListTestFiles(strTestDir)
```

## Arguments

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

## Value

Same as
[`testthat::find_test_scripts()`](https://testthat.r-lib.org/reference/find_test_scripts.html).
This function exists for easier mocking during tests.
