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
  expect_equal(
    {
      CompileTestResults(lEmptyResults)
    },
    tibble::tibble(
      Description = character(),
      File = character(),
      Disposition = factor(levels = c("pass", "fail", "skip")),
      IssueNumbers = list()
    )
  )
})

test_that("CompileTestResults returns the expected object (#32)", {
  lTestResults <- GenerateStandardTestResults()
  expect_equal(
    {
      CompileTestResults(lTestResults)
    },
    tibble::tibble(
      Description = c(
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
        levels = c("pass", "fail", "skip")
      ),
      IssueNumbers = list(
        32L,
        32:34,
        integer(),
        35L
      )
    )
  )
})

test_that("ExtractDisposition() helper errors informatively for weird results", {
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
