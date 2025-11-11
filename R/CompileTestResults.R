#' Extract information from testthat results
#'
#' Extract relevant information from a `testthat_results` object into a tidy
#' [tibble::tibble()].
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_TestResults` object, which is a [tibble::tibble()] with
#'   columns:
#'   - `Test`: The `desc` field of the test from [testthat::test_that()].
#'   - `File`: File where the test is defined.
#'   - `Disposition`: Factor with levels `pass`, `fail`, and `skip` indicating
#'   the overall outcome of the test.
#'   - `Issues`: List column containing integer vectors of associated GitHub
#'   issue numbers.
#' @export
#'
#' @examples
#' # Generate a test results object.
#'
#' # lTestResults <- testthat::test_local(
#' #  stop_on_failure = FALSE,
#' #  reporter = "silent"
#' # )
#'
#' lTestResults <- structure(
#'   list(
#'     list(
#'       file = "test-file1.R",
#'       test = "First test with one GH issue (#32)",
#'       results = list(
#'         structure(
#'           list(),
#'           class = c("expectation_success", "expectation", "condition")
#'         )
#'       )
#'     ),
#'     list(
#'       file = "test-file1.R",
#'       test = "Second test with two GH issues (#32, #45)",
#'       results = list(
#'         structure(
#'           list(),
#'           class = c("expectation_failure", "expectation", "error", "condition")
#'         )
#'       )
#'     )
#'   ),
#'   class = "testthat_results"
#' )
#' CompileTestResults(lTestResults)
CompileTestResults <- function(lTestResults) {
  if (!inherits(lTestResults, "testthat_results")) {
    cli::cli_abort(
      c(
        "Input must be a {.cls testthat_results} object.",
        i = "{.arg lTestResults} is {.obj_type_friendly {lTestResults}}."
      ),
      class = "qcthat-error-bad_input"
    )
  }
  AsTestResultsDF(
    tibble::tibble(
      Test = purrr::map_chr(lTestResults, "test"),
      File = purrr::map_chr(lTestResults, "file"),
      Disposition = CompileDispositions(lTestResults),
      Issues = purrr::map(
        stringr::str_extract_all(.data$Test, "(?<=#)\\d+"),
        as.integer
      )
    )
  )
}

#' Assign the qcthat_TestResults class to a data frame
#'
#' @inheritParams AsExpected
#' @returns A `qcthat_TestResults` object.
#' @keywords internal
AsTestResultsDF <- function(x) {
  AsExpected(
    x,
    EmptyTestResultsDF(),
    chrClass = "qcthat_TestResults"
  )
}

#' Empty test results data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyTestResultsDF <- function() {
  tibble::tibble(
    Test = character(),
    File = character(),
    Disposition = factor(levels = c("fail", "skip", "pass")),
    Issues = list()
  )
}

#' Extract disposition information from testthat results
#'
#' @inheritParams shared-params
#' @returns A factor with levels `pass`, `fail`, and `skip`.
#' @keywords internal
CompileDispositions <- function(lTestResults) {
  factor(
    purrr::map_chr(
      lTestResults,
      ExtractDisposition
    ),
    levels = c("fail", "skip", "pass")
  )
}

#' Extract disposition information from a single testthat result
#'
#' @param lTestResult A single element from a `testthat_results` object.
#' @returns The string `"pass"`, `"fail"`, or `"skip"`.
#' @keywords internal
ExtractDisposition <- function(lTestResult) {
  if (length(lTestResult$results)) {
    classes <- unlist(purrr::map(lTestResult$results, class))
    classes <- setdiff(classes, c("expectation", "condition", "error"))
    if (identical(classes, "expectation_success")) {
      return("pass")
    } else if ("expectation_failure" %in% classes) {
      return("fail")
    } else if ("expectation_skip" %in% classes) {
      return("skip")
    } else if ("expectation_warning" %in% classes) {
      return("fail")
    }
    cli::cli_abort(
      "Unexpected result classes: {.val {classes}}",
      class = "qcthat-error-unexpected_result_class"
    )
  }
  cli::cli_abort(
    c(
      "No test results found.",
      i = "You may need to rerun tests with a different {.arg reporter}.",
      i = "We recommend the {.str silent} reporter."
    ),
    class = "qcthat-error-missing_results"
  )
}
