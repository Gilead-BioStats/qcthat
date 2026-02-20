# Prepare test issue context for analysis

Collect comprehensive information about tests and their potential
related issues using
[`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapTestFilesToPotentialIssues.md),
and enrich with test code and enriched issue details from GitHub.

## Usage

``` r
PrepareTestIssueContext(
  dfPotentialIssues = NULL,
  strTestDir = "tests/testthat",
  strOwner = GetGHOwner(strTestDir),
  strRepo = GetGHRepo(strTestDir),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfPotentialIssues:

  (`tibble`) A data frame as returned by
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapTestFilesToPotentialIssues.md).

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: The `desc` field of the test from
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html).

- `File`: Path to the file where the test is defined, relative to the
  package root.

- `LineStart`: Starting line number of test.

- `LineEnd`: Ending line number of test.

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssueDetails`: List column of tibbles with enriched issue
  details.

- `TestCode`: List column of character vectors containing test code.

## Examples

``` r
if (FALSE) { # interactive()

  PrepareTestIssueContext()
}
```
