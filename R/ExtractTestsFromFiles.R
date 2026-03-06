#' Extract test information from test files
#'
#' @description
#' `r lifecycle::badge("experimental")`
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
#' @returns A list of lists, each containing `Test`, `LineStart`, and
#'   `LineEnd`.
#' @keywords internal
FindTests <- function(chrTestLines) {
  rlang::check_installed("astgrepr", "to find tests.")
  src <- paste(chrTestLines, collapse = "\n")
  root <- astgrepr::tree_new(src) |> astgrepr::tree_root()

  matches <- astgrepr::node_find_all(
    root,
    astgrepr::ast_rule(id = "plain", pattern = "test_that($DESC, $$$)"),
    astgrepr::ast_rule(id = "ns", pattern = "testthat::test_that($DESC, $$$)")
  )

  nodes <- c(matches$plain, matches$ns)

  if (!length(nodes)) {
    return(vctrs::list_of(.ptype = integer()))
  }

  # Sort by start line to preserve file order
  starts <- vapply(
    nodes,
    \(n) astgrepr::node_range(n)[[1]]$start[[1]],
    numeric(1)
  )
  nodes <- nodes[order(starts)]

  purrr::map(nodes, \(node) {
    rng <- astgrepr::node_range(node)[[1]]
    line_start <- as.integer(rng$start[[1]]) + 1L
    line_end <- as.integer(rng$end[[1]]) + 1L

    desc <- astgrepr::node_text(astgrepr::node_get_match(node, "DESC"))[[1]]

    list(Test = desc, LineStart = line_start, LineEnd = line_end)
  }) |>
    purrr::compact()
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
