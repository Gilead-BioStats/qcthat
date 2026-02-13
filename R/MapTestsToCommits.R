#' Map tests to commits
#'
#' Add a column of commit SHAs to a data frame of tests by using git blame to
#' identify which commits last modified each line of each test.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with the same structure as `dfFileTests` plus a
#'   `Commits` list column containing character vectors of unique commit SHAs
#'   that touched each test, in the order they first appear.
#' @keywords internal
MapTestsToCommits <- function(dfFileTests, strTestDir = "tests/testthat") {
  if (!nrow(dfFileTests)) {
    return(dplyr::mutate(dfFileTests, Commits = list()))
  }
  rlang::check_installed("git2r", "to load git blame information")
  chrUniquePaths <- fs::path(strTestDir, unique(dfFileTests$File))
  dfBlames <- purrr::map(chrUniquePaths, BlameFile) |>
    purrr::list_rbind()
  ExpandLines(dfFileTests) |>
    JoinLineCommits(dfBlames)
}

#' Stretch LineStart and LineEnd to Line rows
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with the same structure as `dfFileTests`, but
#'   with a new integer column `Line`, and one row per line.
#' @keywords internal
ExpandLines <- function(dfFileTests) {
  dplyr::mutate(
    dfFileTests,
    Line = list(rlang::seq2(.data$LineStart, .data$LineEnd)),
    .by = c("File", "LineStart", "LineEnd")
  ) |>
    tidyr::unnest_longer("Line")
}

#' Add blames to expanded dfFileTests
#'
#' @inheritParams shared-params
#' @inherit MapTestsToCommits return
#' @keywords internal
JoinLineCommits <- function(dfFileTestsExpanded, dfBlames) {
  dplyr::left_join(dfFileTestsExpanded, dfBlames, by = c("File", "Line")) |>
    dplyr::select(-"Line") |>
    dplyr::mutate(
      Commits = list(unique(unlist(.data$Commits)) %||% character()),
      .by = c("LineStart", "LineEnd")
    ) |>
    dplyr::distinct()
}

#' Git blame a file
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `File`: The file name (character).
#'   - `Line`: Line number (integer).
#'   - `Commits`: List column where each element contains the commit SHA
#'   (character) that last modified that line.
#' @keywords internal
BlameFile <- function(strFilePath) {
  lBlameRaw <- BlameFileRaw(strFilePath)
  if (!length(lBlameRaw$hunks)) {
    return(
      tibble::tibble(File = character(), Line = integer(), Commits = list())
    )
  }
  purrr::map(lBlameRaw$hunks, \(lHunk) {
    EnframeHunk(lHunk, strFilePath)
  }) |>
    purrr::list_rbind()
}

#' Turn a hunk list into a tibble
#'
#' @param lHunk (`list`) A single element of `lBlameRaw$hunks` as returned by
#'   [BlameFileRaw()].
#' @inheritParams shared-params
#' @returns A one-row [tibble::tibble()] with columns:
#'   - `File`: The file name (character).
#'   - `Line`: Line number (integer).
#'   - `Commits`: List column where each element contains the commit SHA
#'   (character) that last modified that line.
#' @keywords internal
EnframeHunk <- function(lHunk, strFilePath) {
  tibble::tibble(
    File = fs::path_file(strFilePath),
    Line = seq(
      from = lHunk$final_start_line_number,
      length.out = lHunk$lines_in_hunk
    ),
    Commits = as.list(rep(lHunk$final_commit_id, lHunk$lines_in_hunk))
  )
}

#' Git blame a file (raw)
#'
#' @inheritParams shared-params
#' @returns The result of [git2r::blame()]. This function exists to make mocking
#'   easier.
#' @keywords internal
BlameFileRaw <- function(strFilePath) {
  git2r::blame(path = strFilePath) # nocov
}
