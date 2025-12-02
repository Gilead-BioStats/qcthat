test_that("CompileTestResults errors informatively for bad input (#32)", {
  expect_error(
    {
      CompileTestResults(123)
    },
    class = "qcthat-error-bad_input"
  )
  expect_snapshot(
    CompileTestResults(123),
    error = TRUE
  )
})

test_that("CompileTestResults works for empty testthat_results (#32)", {
  lEmptyResults <- structure(list(), class = "testthat_results")
  test_result <- CompileTestResults(lEmptyResults)
  expect_s3_class(test_result, "qcthat_TestResults")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expect_equal(
    test_result,
    tibble::tibble(
      Test = character(),
      File = character(),
      Disposition = factor(levels = c("fail", "skip", "pass")),
      Issues = list()
    )
  )
})

test_that("CompileTestResults returns the expected object (#32)", {
  lTestResults <- GenerateStandardTestResults()
  test_result <- CompileTestResults(lTestResults)
  expect_s3_class(test_result, "qcthat_TestResults")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expect_equal(
    test_result,
    tibble::tibble(
      Test = c(
        "First test with one GH issue (#32)",
        "Second test with multiple GH issues (#32, #33, #34)",
        "Third test with 0 GH issues, failure",
        "Fourth test with 1 GH issue, skipped (#35)"
      ),
      File = c(
        "test-file1.R",
        "test-file1.R",
        "test-file2.R",
        "test-file2.R"
      ),
      Disposition = factor(
        c("pass", "pass", "fail", "skip"),
        levels = c("fail", "skip", "pass")
      ),
      Issues = list(
        32L,
        32:34,
        integer(),
        35L
      )
    )
  )
})

test_that("ExtractDisposition() helper counts warnings as errors (#32)", {
  lTestResult <- list(
    results = list(
      structure(
        list(),
        class = c("expectation_warning", "expectation", "condition")
      )
    )
  )
  expect_equal(ExtractDisposition(lTestResult), "fail")
})

test_that("ExtractDisposition() helper errors informatively for weird results (#32)", {
  lTestResult <- list(
    results = list(
      structure(
        list(),
        class = c("some_weird_class", "expectation", "condition")
      )
    )
  )
  expect_error(
    {
      ExtractDisposition(lTestResult)
    },
    class = "qcthat-error-unexpected_result_class"
  )
  expect_snapshot(
    ExtractDisposition(lTestResult),
    error = TRUE
  )
})

test_that("ExtractDisposition() helper errors informatively for missing results within lTestResult object (#45)", {
  lTestResult <- list(
    results = list()
  )
  expect_error(
    {
      ExtractDisposition(lTestResult)
    },
    class = "qcthat-error-missing_results"
  )
  expect_snapshot(
    ExtractDisposition(lTestResult),
    error = TRUE
  )
})

test_that("ExtractDisposition() helper counts test errors as failures (#67)", {
  lTestResult <- list(
    results = list(
      structure(
        list(),
        class = c("expectation_error", "expectation", "condition")
      )
    )
  )
  expect_equal(ExtractDisposition(lTestResult), "fail")
})
