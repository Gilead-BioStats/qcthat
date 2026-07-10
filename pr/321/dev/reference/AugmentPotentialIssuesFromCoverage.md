# Augment test potential issues with source-line coverage

Augment test potential issues with source-line coverage

## Usage

``` r
AugmentPotentialIssuesFromCoverage(
  dfTestBlame,
  dfFileTests,
  dfIssueCommitsLong,
  strTestDir,
  envCall = rlang::caller_env()
)
```

## Arguments

- dfTestBlame:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  as returned by
  [`GatherPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/GatherPotentialIssues.md),
  with columns `Test`, `File`, `LineStart`, `LineEnd`, `Issues`, and
  `PotentialIssues`.

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).

- dfIssueCommitsLong:

  (`data.frame` or `NULL`) Pre-computed issue-commit mappings from
  [`MapLongIssueCommits()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapLongIssueCommits.md).
  If `NULL` (the default), fetched automatically from the GitHub API.
  Provide this when calling
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapTestFilesToPotentialIssues.md)
  multiple times to avoid redundant API requests.

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
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the file where the test is defined, relative to the
  package root.

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssues`: List column containing integer vectors of issue
  numbers that might be related to each test based on commit history of
  the test (and of the functions exercised by the test, when
  `lglUseCoverage` is `TRUE`).
