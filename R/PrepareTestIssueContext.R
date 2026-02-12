#' Prepare test issue context for analysis
#'
#' Collect comprehensive information about tests and their potential related
#' issues using [MapTestFilesToPotentialIssues()], and enrich with test code and
#' enriched issue details from GitHub.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Test`: Test description (character).
#'   - `File`: Test file name (character).
#'   - `LineStart`: Starting line number of test.
#'   - `LineEnd`: Ending line number of test.
#'   - `Issues`: List column containing integer vectors of issue numbers already
#'   tagged in the test description.
#'   - `PotentialIssueDetails`: List column of tibbles with enriched issue
#'   details.
#'   - `TestCode`: List column of character vectors containing test code.
#' @export
#'
#' @examplesIf interactive()
#'
#'   PrepareTestIssueContext()
PrepareTestIssueContext <- function(
  dfPotentialIssues = NULL,
  strTestDir = "tests/testthat",
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfPotentialIssues <- dfPotentialIssues %||%
    MapTestFilesToPotentialIssues(
      strTestDir = strTestDir,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  if (!nrow(dfPotentialIssues)) {
    return(EmptyTestIssueContextDF())
  }
  EnrichWithIssueDetails(dfPotentialIssues, strOwner, strRepo, strGHToken) |>
    EnrichWithTestCode(strTestDir)
}

#' Create empty test issue context data frame
#'
#' @inherit PrepareTestIssueContext return
#' @keywords internal
EmptyTestIssueContextDF <- function() {
  tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = list(),
    PotentialIssueDetails = list(),
    TestCode = list()
  )
}

#' Enrich data frame with issue details
#'
#' @inheritParams shared-params
#' @returns The input data frame with `PotentialIssues` enriched to
#'   `PotentialIssueDetails` with issue details.
#' @keywords internal
EnrichWithIssueDetails <- function(
  dfPotentialIssues,
  strOwner,
  strRepo,
  strGHToken
) {
  dplyr::mutate(
    dfPotentialIssues,
    PotentialIssueDetails = purrr::map(.data$PotentialIssues, \(intIssues) {
      FetchIssueDetails(intIssues, strOwner, strRepo, strGHToken)
    })
  ) |>
    dplyr::select(-"PotentialIssues")
}

#' Enrich data frame with test code
#'
#' @param dfTestPotentialIssueDetails (`tibble`) A data frame as returned by
#'   [EnrichWithIssueDetails()].
#' @inheritParams shared-params
#' @returns The input data frame with a `TestCode` list column added.
#' @keywords internal
EnrichWithTestCode <- function(dfTestPotentialIssueDetails, strTestDir) {
  dplyr::mutate(
    dfTestPotentialIssueDetails,
    TestCode = purrr::pmap(
      list(.data$File, .data$LineStart, .data$LineEnd),
      \(strFile, intLineStart, intLineEnd) {
        ReadTestCode(strFile, intLineStart, intLineEnd, strTestDir)
      }
    )
  )
}
