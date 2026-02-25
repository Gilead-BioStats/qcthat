test_that("QCPR errors informatively for bad intPRNumber (#84)", {
  expect_error(
    {
      QCPR(intPRNumber = NULL)
    },
    class = "qcthat-error-pr_number_not_found"
  )
})

test_that("QCPR filters to PR-related issues (#68, #84)", {
  # Really this just tests that it calls the right things, but we test those
  # things under the hood.
  local_mocked_bindings(
    FetchPRIssueNumbers = function(intPRNumber, ...) {
      expect_equal(intPRNumber, 123)
      1:3
    },
    QCIssues = function(intIssues, ...) {
      paste(intIssues, collapse = "|")
    }
  )
  expect_identical(QCPR(intPRNumber = 123), "1|2|3")
})
