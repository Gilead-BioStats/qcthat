#' Map test files to potential issues
#'
#' Identify potential issues for each test by matching commits that last modified
#' the test with commits that closed issues. Tests tagged with `#noissue` are
#' excluded from the results.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Test`: Test description (character).
#'   - `File`: Test file name (character).
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
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfTestCommitsLong <- ExtractLongTestCommits(strTestDir, dfFileTests)
  if (!nrow(dfTestCommitsLong)) {
    return(EmptyTestPotentialIssues())
  }

  # Fetch issue-to-commit mappings once to avoid redundant API calls
  dfIssueCommitsLong <- MapLongIssueCommits(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
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
      ExtractTestsFromFiles(strTestDir = strTestDir),
    strTestDir = strTestDir
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
    Issues = list(),
    PotentialIssues = list()
  )
}

#' Map issues to commits in long format
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with one row per issue-commit pair, containing
#'   columns `Issue` and `Commits`.
#' @keywords internal
MapLongIssueCommits <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  MapRepoIssuesToCommits(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
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
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfIssueCommitsLong <- dfIssueCommitsLong %||%
    MapLongIssueCommits(
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
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
