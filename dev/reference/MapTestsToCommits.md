# Map tests to commits

Add a column of commit SHAs to a data frame of tests by using git blame
to identify which commits last modified each line of each test.

## Usage

``` r
MapTestsToCommits(dfFileTests, envCall = rlang::caller_env())
```

## Arguments

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as `dfFileTests` plus a `Commits` list column
containing character vectors of unique commit SHAs that touched each
test, in the order they first appear.
