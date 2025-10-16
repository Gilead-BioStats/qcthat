#' Extract information from testthat results
#'
#' Extract relevant information from a `testthat_results` object into a tidy
#' tibble format.
#'
#' @param lTestResults A `testthat_results` object, typically obtained by
#'   running something like `testthat::test_local(stop_on_failure = FALSE)` and
#'   assigning it to a name.
#'
#' @returns A tibble with columns:
#'   - `test`: Name of the test.
#'   - `file`: File where the test is located.
#'   - `disposition`: Factor with levels `pass`, `fail`, and `skip` indicating the
#'   overall outcome of the test.
#'   - `issues`: List column containing integer vectors of associated GitHub issue
#'   numbers extracted from the test names.
#' @export
#'
#' @examples
#' # Generate a test results object.
#'
#' # lTestResults <- testthat::test_local(stop_on_failure = FALSE)
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
  return(
    tibble::tibble(
      test = purrr::map_chr(lTestResults, "test"),
      file = purrr::map_chr(lTestResults, "file"),
      disposition = .CompileDispositions(lTestResults),
      issues = purrr::map(
        stringr::str_extract_all(.data$test, "(?<=#)\\d+"),
        as.integer
      )
    )
  )
}

#' Extract disposition information from testthat results
#'
#' @inheritParams CompileTestResults
#' @returns A factor with levels `pass`, `fail`, and `skip`.
#' @keywords internal
.CompileDispositions <- function(lTestResults) {
  factor(
    purrr::map_chr(
      lTestResults,
      .ExtractDisposition
    ),
    levels = c("pass", "fail", "skip")
  )
}

#' Extract disposition information from a single testthat result
#'
#' @param lTestResult A single element from a `testthat_results` object.
#' @returns The string `"pass"`, `"fail"`, or `"skip"`.
#' @keywords internal
.ExtractDisposition <- function(lTestResult) {
  classes <- unlist(purrr::map(lTestResult$results, class))
  classes <- setdiff(classes, c("expectation", "condition", "error"))
  if (identical(classes, "expectation_success")) {
    return("pass")
  } else if ("expectation_failure" %in% classes) {
    return("fail")
  } else if ("expectation_skip" %in% classes) {
    return("skip")
  }
  cli::cli_abort(
    c(
      "Unexpected result classes: {.val {classes}}"
    ),
    class = "qcthat-error-unexpected_result_class"
  )
}
