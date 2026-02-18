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

test_that("FetchPRRefs returns source and target refs (#84, #133, #149)", {
  local_mocked_bindings(
    CallGHAPI = function(..., pull_number = 0, ref = "") {
      if (pull_number == 123) {
        return(
          list(head = list(ref = "feature-branch"), base = list(ref = "dev"))
        )
      }
      if (pull_number == 456) {
        return(
          list(
            merged = TRUE,
            merge_commit_sha = "merge-sha-456"
          )
        )
      }
      if (ref == "merge-sha-456") {
        return(
          list(
            parents = list(
              list(sha = "parent-sha-1"),
              list(sha = "parent-sha-2")
            )
          )
        )
      }
      stop()
    }
  )
  expect_equal(
    FetchPRRefs(intPRNumber = 123),
    c(strSourceRef = "feature-branch", strTargetRef = "dev")
  )
  expect_equal(
    FetchPRRefs(intPRNumber = 456),
    c(strSourceRef = "merge-sha-456", strTargetRef = "parent-sha-1")
  )
  expect_error(
    FetchPRRefs(
      intPRNumber = 999
    ),
    "must refer to a pull request in the specified repository",
    class = "qcthat-error-pr_not_found"
  )
})

test_that("FetchPRRefs calls LookupPRFromList when lPRs is provided (#noissue)", {
  lPRsTest <- list("not empty")
  intPRNumberTest <- 123L
  local_mocked_bindings(
    LookupPRFromList = function(lPRs, intPRNumber, envCall) {
      cli::cli_inform("Called LookupPRFromList")
      expect_identical(intPRNumber, intPRNumberTest)
      expect_identical(lPRs, lPRsTest)
      list()
    }
  )
  expect_no_error(
    FetchPRRefs(intPRNumber = intPRNumberTest, lPRs = lPRsTest)
  ) |>
    expect_message("Called LookupPRFromList")
})
