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

test_that("FetchMergeCommitSHAs returns unique, sorted SHAs (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, source, ...) {
      if (source == "source") {
        list(
          commits = list(
            list(sha = "abc"),
            list(sha = "def"),
            list(sha = "abc"),
            list(sha = "123")
          )
        )
      } else {
        list(commits = list())
      }
    }
  )
  expect_equal(FetchMergeCommitSHAs("source", "target"), c("123", "abc", "def"))
  expect_equal(FetchMergeCommitSHAs("other", "target"), character(0))
})

test_that("FetchAllMergePRNumbers returns unique, sorted PR numbers (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        commit1 = list(
          associatedPullRequests = list(
            nodes = list(list(number = 101), list(number = 102))
          )
        ),
        commit2 = list(
          associatedPullRequests = list(
            nodes = list(list(number = 102), list(number = 103))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllMergePRNumbers(c("sha1", "sha2")),
    c(101, 102, 103)
  )
  expect_equal(
    FetchAllMergePRNumbers(character(0)),
    integer(0)
  )
})

test_that("FetchAllMergePRNumbers returns empty vector for no matching PRs (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(commit1 = list(associatedPullRequests = list(nodes = list())))
    }
  )
  expect_equal(
    FetchAllMergePRNumbers("sha1"),
    integer(0)
  )
})

test_that("FetchAllPRIssueNumbers returns unique, sorted issue numbers (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        pr12 = list(
          closingIssuesReferences = list(
            nodes = list(list(number = 1), list(number = 2))
          )
        ),
        pr34 = list(
          closingIssuesReferences = list(
            nodes = list(list(number = 2), list(number = 3))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllPRIssueNumbers(c(12, 34)),
    1:3
  )
  expect_equal(FetchAllPRIssueNumbers(integer(0)), integer(0))
})

test_that("FetchAllPRIssueNumbers returns empty vector for no matching issues (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(pr12 = list(closingIssuesReferences = list(nodes = list())))
    }
  )
  expect_equal(FetchAllPRIssueNumbers(12), integer(0))
})
