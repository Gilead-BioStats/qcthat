test_that("QCPackage wraps the core qcthat functions (#46, #69)", {
  local_mocked_bindings(
    FetchRepoIssues = function(...) "repo issues",
    GetPkgRoot = function(strPkgRoot, ...) strPkgRoot,
    CompileTestResults = function(...) "test results",
    CompileIssueTestMatrix = function(...) paste(..., sep = "|")
  )
  expect_identical(
    QCPackage(
      strPkgRoot = "package root",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "repo issues|test results"
  )
})

test_that("QCCompletedIssues filters to completed issues (#80, #69)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        StateReason = c(NA, "completed", "other", "completed"),
        OtherColumn = 1:4
      )
    }
  )
  test_result <- QCCompletedIssues(
    strPkgRoot = "package root",
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expected_result <- tibble::tibble(
    StateReason = c("completed", "completed"),
    OtherColumn = c(2L, 4L)
  )
  expect_identical(test_result, expected_result)
})

test_that("QCMergeLocal filters to ref-specific issues (#68, #84)", {
  local_mocked_bindings(
    FindKeywordIssues = function(...) {
      3:4
    },
    QCPackage = function(...) {
      tibble::tibble(
        Issue = c(NA, 1:5),
        OtherColumn = 1:6
      )
    }
  )
  expected_result <- tibble::tibble(Issue = 3:4, OtherColumn = 4:5)
  expect_identical(QCMergeLocal(), expected_result)
})

test_that("QCIssues reports on specific issues (#86)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L, 3L),
        OtherColumn = 1:3
      )
    }
  )
  expected_result <- tibble::tibble(Issue = 2:3, OtherColumn = 2:3)
  expect_identical(QCIssues(2:3), expected_result)
})

test_that("QCIssues warns about unknown issues (#86)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L, 3L),
        OtherColumn = 1:3
      )
    }
  )
  expect_warning(
    test_result <- QCIssues(2:4),
    "Unknown issues: 4",
    class = "qcthat-warning-unknown_issues"
  )
  expected_result <- tibble::tibble(Issue = 2:3, OtherColumn = 2:3)
  expect_identical(test_result, expected_result)
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

test_that("QCMergeGH filters to merge-associated issues (#68, #84)", {
  # Really this just tests that it calls the right things, but we test those
  # things under the hood.
  local_mocked_bindings(
    FetchMergeCommitSHAs = function(strSourceRef, strTargetRef, ...) {
      expect_equal(strSourceRef, "source")
      expect_equal(strTargetRef, "target")
      c("sha1", "sha2")
    },
    FetchAllMergePRNumbers = function(chrCommitSHAs, ...) {
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
      c(101, 102)
    },
    FetchAllPRIssueNumbers = function(intPRNumbers, ...) {
      expect_equal(intPRNumbers, c(101, 102))
      c(1, 2, 3)
    },
    QCIssues = function(intIssues, ...) {
      expect_equal(intIssues, c(1, 2, 3))
      "Final Report"
    }
  )
  expect_identical(
    QCMergeGH(strSourceRef = "source", strTargetRef = "target"),
    "Final Report"
  )
})
