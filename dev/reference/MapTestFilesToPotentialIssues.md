# Map test files to potential issues

Identify potential issues for each test by matching commits that last
modified the test with commits that closed issues. Tests tagged with
`#noissue` are excluded from the results.

## Usage

``` r
MapTestFilesToPotentialIssues(
  dfFileTests = NULL,
  strTestDir = "tests/testthat",
  dfIssueCommitsLong = NULL,
  strOwner = GetGHOwner(strTestDir),
  strRepo = GetGHRepo(strTestDir),
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md).

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- dfIssueCommitsLong:

  (`data.frame` or `NULL`) Pre-computed issue-commit mappings from
  [`MapLongIssueCommits()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapLongIssueCommits.md).
  If `NULL` (the default), fetched automatically from the GitHub API.
  Provide this when calling `MapTestFilesToPotentialIssues()` multiple
  times to avoid redundant API requests.

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

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssues`: List column containing integer vectors of issue
  numbers that might be related to each test based on commit history.

## Examples

``` r
if (FALSE) { # interactive()

  MapTestFilesToPotentialIssues()
}
```
