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
})

test_that("FetchPRRefs errors if PR number is not found (#84)", {
  local_mocked_bindings(
    FetchRepoPRs = function(...) {
      tibble::tibble(
        PR = c(123, 124),
        HeadRef = c("feature-branch", "other-branch"),
        BaseRef = c("dev", "main")
      )
    }
  )
  expect_error(
    FetchPRRefs(intPRNumber = 999, strOwner = "owner", strRepo = "repo"),
    "must refer to a pull request in the specified repository",
    class = "qcthat-error-pr_not_found"
  )
})
