#' Map test files to potential issues
#'
#' Identify potential issues for each test by matching commits that last modified
#' the test with commits that closed issues. Tests tagged with `#noissue` are
#' excluded from the results.
#'
#' When processing multiple test files, pre-compute `dfIssueCommitsLong` once
#' with [MapLongIssueCommits()] and pass it to each call to avoid redundant
#' GitHub API requests:
#'
#' ```r
#' dfIssueCommitsLong <- MapLongIssueCommits()
#' results <- purrr::map(
#'   lFileTestsSplit,
#'   MapTestFilesToPotentialIssues,
#'   dfIssueCommitsLong = dfIssueCommitsLong
#' )
#' ```
#'
#' @param dfIssueCommitsLong (`data.frame` or `NULL`) Pre-computed issue-commit
#'   mappings from [MapLongIssueCommits()]. If `NULL` (the default), fetched
#'   automatically from the GitHub API. Provide this when calling
#'   [MapTestFilesToPotentialIssues()] multiple times to avoid redundant API
#'   requests.
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Test`: The `desc` field of the test from [testthat::test_that()].
#'   - `File`: Path to the file where the test is defined, relative to the
#'   package root.
#'   - `Issues`: List column containing integer vectors of issue numbers already
#'   tagged in the test description.
#'   - `PotentialIssues`: List column containing integer vectors of issue
#'   numbers that might be related to each test based on commit history.
#' @export
#'
#' @examplesIf interactive()
#'
#'   MapTestFilesToPotentialIssues()
MapTestFilesToPotentialIssues <- function(
  dfFileTests = NULL,
  strTestDir = "tests/testthat",
  dfIssueCommitsLong = NULL,
  strOwner = GetGHOwner(strTestDir),
  strRepo = GetGHRepo(strTestDir),
  strGHToken = gh::gh_token()
) {
  dfTestCommitsLong <- ExtractLongTestCommits(strTestDir, dfFileTests)
  if (!nrow(dfTestCommitsLong)) {
    return(EmptyTestPotentialIssues())
  }

  dfIssueCommitsLong <- dfIssueCommitsLong %||% MapLongIssueCommits(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strPkgRoot = strTestDir
  )

  MapTestsToPotentialIssues(
    dfTestCommitsLong,
    dfIssueCommitsLong = dfIssueCommitsLong
  ) |>
    GatherPotentialIssues()
}

#' Extract test-commit pairs in long format
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with one row per test-commit pair, containing
#'   columns `Test`, `File`, `LineStart`, `LineEnd`, `Issues`, and `Commits`.
#' @keywords internal
ExtractLongTestCommits <- function(
  strTestDir = "tests/testthat",
  dfFileTests = NULL
) {
  MapTestsToCommits(
    dfFileTests = dfFileTests %||%
      ExtractTestsFromFiles(strTestDir = strTestDir)
  ) |>
    dplyr::filter(!.data$TaggedNoIssue) |>
    dplyr::select(-"TaggedNoIssue") |>
    tidyr::unnest_longer("Commits")
}

#' Empty test potential issues data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyTestPotentialIssues <- function() {
  tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    PotentialIssues = vctrs::list_of(.ptype = integer())
  )
}

#' Map issues to commits in long format
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with one row per issue-commit pair, containing
#'   columns `Issue` and `Commits`.
#' @keywords internal
MapLongIssueCommits <- function(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  strPkgRoot <- GetPkgRoot(strPkgRoot)
  MapRepoIssuesToCommits(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strPkgRoot = strPkgRoot
  ) |>
    tidyr::unnest_longer("Commits")
}

#' Map tests to potential issues via commit joins
#'
#' @param dfTestCommitsLong A [tibble::tibble()] with one row per test-commit
#'   pair, typically from [ExtractLongTestCommits()].
#' @param dfIssueCommitsLong A [tibble::tibble()] with one row per issue-commit
#'   pair, typically from [MapLongIssueCommits()]. If `NULL`, will be fetched.
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] in long format with columns `Test`, `File`,
#'   `Issues`, and `Issue` (the potential issue number).
#' @keywords internal
MapTestsToPotentialIssues <- function(
  dfTestCommitsLong,
  dfIssueCommitsLong = NULL,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  dfIssueCommitsLong <- dfIssueCommitsLong %||%
    MapLongIssueCommits(
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken,
      strPkgRoot = strPkgRoot
    )

  dplyr::left_join(
    dfTestCommitsLong,
    dfIssueCommitsLong,
    by = "Commits",
    relationship = "many-to-many"
  ) |>
    dplyr::select(-"Commits")
}

#' Gather potential issues into list column
#'
#' @param dfTestPotentialIssuesLong A [tibble::tibble()] in long format with one
#'   row per test-issue pair, typically from [MapTestsToPotentialIssues()].
#' @inherit MapTestFilesToPotentialIssues return
#' @keywords internal
GatherPotentialIssues <- function(dfTestPotentialIssuesLong) {
  dplyr::summarize(
    dfTestPotentialIssuesLong,
    PotentialIssues = list(sort(unique(.data$Issue))),
    .by = "Test":"Issues"
  )
}
