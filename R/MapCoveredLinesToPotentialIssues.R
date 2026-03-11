#' Map covered source lines to potential issues
#'
#' @param dfTestCoveredLines (`tibble`) Output of [MapTestsToCoveredLines()].
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with the same structure as
#'   [MapTestFilesToPotentialIssues()].
#' @keywords internal
MapCoveredLinesToPotentialIssues <- function(
  dfTestCoveredLines,
  dfIssueCommitsLong
) {
  if (!nrow(dfTestCoveredLines)) {
    return(EmptyTestPotentialIssues())
  }

  dfSourceBlames <- BlameFiles(unique(dfTestCoveredLines$SourceFile))

  dfLong <- dplyr::left_join(
    dfTestCoveredLines,
    dfSourceBlames,
    by = c("SourceFile" = "File", "Line")
  ) |>
    dplyr::select(-"SourceFile", -"Line") |>
    tidyr::unnest_longer("Commits") |>
    dplyr::distinct()

  MapTestsToPotentialIssues(dfLong, dfIssueCommitsLong = dfIssueCommitsLong) |>
    GatherPotentialIssues()
}

#' Merge two sets of potential issues per test
#'
#' Union `PotentialIssues` from two data frames (e.g., test-blame and
#' source-blame) per test, deduplicating and sorting.
#'
#' @param dfA (`tibble`) First potential issues data frame.
#' @param dfB (`tibble`) Second potential issues data frame.
#' @returns A [tibble::tibble()] with the same structure as
#'   [MapTestFilesToPotentialIssues()], with `PotentialIssues` unioned.
#' @keywords internal
MergePotentialIssues <- function(dfA, dfB) {
  dfMerged <- dplyr::full_join(
    dfA,
    dfB,
    by = c("Test", "File", "LineStart", "LineEnd", "Issues"),
    suffix = c("_a", "_b")
  )
  dplyr::mutate(
    dfMerged,
    PotentialIssues = purrr::map2(
      .data$PotentialIssues_a %||% list(),
      .data$PotentialIssues_b %||% list(),
      \(a, b) sort(unique(c(a, b)))
    )
  ) |>
    dplyr::select(-"PotentialIssues_a", -"PotentialIssues_b")
}
