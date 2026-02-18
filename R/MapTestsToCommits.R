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
MapTestsToCommits <- function(dfFileTests, envCall = rlang::caller_env()) {
  if (!nrow(dfFileTests)) {
    return(dplyr::mutate(dfFileTests, Commits = list()))
  }
  rlang::check_installed("git2r", "to load git blame information")
  chrUniquePaths <- unique(dfFileTests$File)
  dfBlames <- purrr::map(chrUniquePaths, \(strFilePath) {
    BlameFile(strFilePath, envCall = envCall)
  }) |>
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
#'   - `File`: Path to the file, relative to the package root.
#'   - `Line`: Line number (integer).
#'   - `Commits`: List column where each element contains the commit SHA
#'   (character) that last modified that line.
#' @keywords internal
BlameFile <- function(strFilePath, envCall = rlang::caller_env()) {
  lBlameRaw <- BlameFileRaw(strFilePath, envCall = envCall)
  if (!length(lBlameRaw$hunks)) {
    return(
      tibble::tibble(File = character(), Line = integer(), Commits = list())
    )
  }
  purrr::map(lBlameRaw$hunks, \(lHunk) {
    EnframeHunk(lHunk, strFilePath, envCall = envCall)
  }) |>
    purrr::list_rbind()
}

#' Turn a hunk list into a tibble
#'
#' @param lHunk (`list`) A single element of `lBlameRaw$hunks` as returned by
#'   [BlameFileRaw()].
#' @inheritParams shared-params
#' @returns A one-row [tibble::tibble()] with columns:
#'   - `File`: Path to the file, relative to the package root.
#'   - `Line`: Line number (integer).
#'   - `Commits`: List column where each element contains the commit SHA
#'   (character) that last modified that line.
#' @keywords internal
EnframeHunk <- function(lHunk, strFilePath, envCall = rlang::caller_env()) {
  tibble::tibble(
    File = strFilePath,
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
BlameFileRaw <- function(strFilePath, envCall = rlang::caller_env()) {
  # nocov start
  strPkgRoot <- GetPkgRoot(strFilePath, envCall = envCall)
  strFilePath <- GetRelativePackagePath(strFilePath, envCall = envCall)
  git2r::blame(path = strFilePath, repo = strPkgRoot)
  # nocov end
}

#' Find the path to a file
#'
#' @inheritParams shared-params
#' @returns The path to a file, relative to the root of the package that the
#'   file is within.
#' @keywords internal
GetRelativePackagePath <- function(strFilePath, envCall = rlang::caller_env()) {
  strPkgRoot <- GetPkgRoot(strFilePath, envCall = envCall)
  fs::path_rel(strFilePath, strPkgRoot)
}
