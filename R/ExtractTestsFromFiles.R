#' Extract test information from test files
#'
#' Parse test files in a directory to extract test descriptions, file locations,
#' line numbers, and associated GitHub issue numbers.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Test`: The `desc` field of the test from [testthat::test_that()].
#'   - `File`: Path to the file where the test is defined, relative to the
#'   package root.
#'   - `LineStart`: First line of the test.
#'   - `LineEnd`: Last line of the test.
#'   - `Issues`: List column containing integer vectors of associated GitHub
#'   issue numbers.
#'   - `TaggedNoIssue`: Logical indicating whether the test is tagged with
#'   `#noissue`.
#' @export
#' @examplesIf interactive()
#'
#'   # Extract all tests
#'   ExtractTestsFromFiles()
#'
#'   # Find tests with no linked issues
#'   ExtractTestsFromFiles() |>
#'     dplyr::filter(!lengths(Issues), !TaggedNoIssue)
ExtractTestsFromFiles <- function(
  strTestDir = "tests/testthat",
  envCall = rlang::caller_env()
) {
  chrFilePaths <- ListTestFiles(strTestDir)
  if (!length(chrFilePaths)) {
    return(EmptyFileTestsDF())
  }
  purrr::map(chrFilePaths, \(strFilePath) {
    ExtractTestsFromFile(strFilePath, envCall)
  }) |>
    purrr::list_rbind()
}

#' Find test files
#'
#' @inheritParams shared-params
#' @returns Same as [testthat::find_test_scripts()]. This function exists for
#'   easier mocking during tests.
#' @keywords internal
ListTestFiles <- function(strTestDir) {
  testthat::find_test_scripts(strTestDir)
}

#' Extract test information from a single file
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with the same structure as
#'   [ExtractTestsFromFiles()].
#' @keywords internal
ExtractTestsFromFile <- function(strFilePath, envCall = rlang::caller_env()) {
  chrTestLines <- readLines(strFilePath, warn = FALSE)
  lTests <- FindTests(chrTestLines)
  if (!length(lTests)) {
    return(EmptyFileTestsDF())
  }
  tidyr::unnest_wider(
    tibble::as_tibble_col(lTests),
    "value"
  ) |>
    dplyr::mutate(
      File = fs::path_rel(strFilePath),
      .before = "LineStart"
    ) |>
    dplyr::mutate(
      Issues = ExtractTestIssues(.data$Test),
      TaggedNoIssue = stringr::str_detect(.data$Test, "#noissue")
    )
}

#' Find test_that calls in a file
#'
#' @inheritParams shared-params
#' @returns A list of lists, each containing `desc`, `start`, and `end`.
#' @keywords internal
FindTests <- function(chrTestLines) {
  intTestStarts <- stringr::str_which(chrTestLines, "^\\s*test_that\\(")
  if (!length(intTestStarts)) {
    return(vctrs::list_of(.ptype = integer()))
  }
  purrr::map(intTestStarts, \(intTestStart) {
    ParseTest(chrTestLines, intTestStart)
  }) |>
    purrr::compact()
}

#' Parse a single test_that call
#'
#' @inheritParams shared-params
#' @returns A list with `desc`, `start`, and `end`, or NULL if parsing fails.
#' @keywords internal
ParseTest <- function(chrTestLines, intTestStart) {
  strCode <- paste(
    chrTestLines[intTestStart:length(chrTestLines)],
    collapse = "\n"
  )
  exprParsed <- tryCatch(
    parse(text = strCode, n = 1, keep.source = TRUE),
    error = function(e) return(NULL)
  )
  if (!length(exprParsed)) {
    return(NULL)
  }
  exprCall <- exprParsed[[1]]
  if (!rlang::is_call(exprCall, "test_that")) {
    return(NULL)
  }
  strDesc <- tryCatch(
    as.character(eval(exprCall[[2]])),
    error = function(e) return(NULL)
  )
  if (!length(strDesc)) {
    return(NULL)
  }
  intEnd <- intTestStart +
    length(as.character(attr(exprParsed, "srcref")[[1]])) -
    1L
  list(Test = strDesc, LineStart = intTestStart, LineEnd = intEnd)
}

#' Extract issue numbers from test descriptions
#'
#' @inheritParams shared-params
#' @returns A list of integer vectors of sorted unique issue numbers.
#' @keywords internal
ExtractTestIssues <- function(chrTests) {
  stringr::str_extract_all(chrTests, "(?<=#)\\d+") |>
    purrr::map(\(intIssues) sort(unique(as.integer(intIssues))))
}

#' Empty file tests data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyFileTestsDF <- function() {
  tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    TaggedNoIssue = logical()
  )
}
