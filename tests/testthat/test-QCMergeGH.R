test_that("QCMergeGH filters to merge-associated issues (#68, #84)", {
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
    FetchAllPRIssueNumbers = function(...) integer(),
    FetchMergeIssueClosers = function(intPRNumbers, chrCommitSHAs, ...) {
      expect_equal(intPRNumbers, c(101, 102))
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
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
