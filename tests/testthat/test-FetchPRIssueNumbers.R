test_that("FetchPRRefs returns source and target refs (#84, #133, #149)", {
  local_mocked_bindings(
    CallGHAPI = function(..., pull_number = 0) {
      if (pull_number == 123) {
        return(
          list(head = list(ref = "feature-branch"), base = list(ref = "dev"))
        )
      }
      if (pull_number == 456) {
        return(list(merged = TRUE, merge_commit_sha = "merge-sha-456"))
      }
      stop()
    },
    GetGitCommitInfo = function(strRef, strPkgRoot) {
      list(parents = c("parent-sha-1", "parent-sha-2"))
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
    FetchPRRefs(intPRNumber = 999),
    "must refer to a pull request in the specified repository",
    class = "qcthat-error-pr_not_found"
  )
})

test_that("FetchPRRefs errors when local git lookup fails for merged PR (#noissue)", {
  local_mocked_bindings(
    FetchRawRepoPRSingle = function(...) {
      list(merged = TRUE, merge_commit_sha = "merge-sha")
    },
    GetGitCommitInfo = function(...) stop("not available locally")
  )
  expect_error(FetchPRRefs(intPRNumber = 1L), "not available locally")
})

test_that("FetchPRIssueNumbers makes the expected calls (#noissue)", {
  local_mocked_bindings(
    FetchPRRefs = function(intPRNumber, ...) {
      expect_equal(intPRNumber, 123)
      c(strSourceRef = "source", strTargetRef = "target")
    },
    FetchMergeIssueNumbers = function(strSourceRef, strTargetRef, ...) {
      expect_equal(strSourceRef, "source")
      expect_equal(strTargetRef, "target")
      1:3
    }
  )
  expect_equal(
    FetchPRIssueNumbers(intPRNumber = 123),
    1:3
  )
})
