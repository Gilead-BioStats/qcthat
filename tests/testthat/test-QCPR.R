test_that("QCPR filters to PR-related issues (#68, #84)", {
  # Really this just tests that it calls the right things, but we test those
  # things under the hood.
  local_mocked_bindings(
    FetchPRRefs = function(intPRNumber, ...) {
      expect_equal(intPRNumber, 123)
      c(strSourceRef = "feature-branch", strTargetRef = "dev")
    },
    QCMergeGH = function(strSourceRef, strTargetRef, ...) {
      paste(strSourceRef, strTargetRef, sep = "|")
    }
  )
  expect_identical(QCPR(intPRNumber = 123), "feature-branch|dev")
})

test_that("FetchPRRefs returns source and target refs (#84)", {
  local_mocked_bindings(
    FetchRepoPRs = function(...) {
      tibble::tibble(
        PR = c(123, 124),
        HeadRef = c("feature-branch", "other-branch"),
        BaseRef = c("dev", "main")
      )
    }
  )
  expect_equal(
    FetchPRRefs(intPRNumber = 123),
    c(strSourceRef = "feature-branch", strTargetRef = "dev")
  )
  expect_error(
    FetchPRRefs(intPRNumber = 999, strOwner = "owner", strRepo = "repo"),
    "must refer to a pull request in the specified repository",
    class = "qcthat-error-pr_not_found"
  )
})
