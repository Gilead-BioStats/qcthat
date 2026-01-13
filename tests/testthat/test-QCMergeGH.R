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
    FetchAllMergeIssueNumbers = function(intPRNumbers, chrCommitSHAs, ...) {
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

test_that("FetchMergeCommitSHAs returns unique, sorted SHAs (#84, #133)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, source, page = 1, ...) {
      if (source == "source") {
        return(
          list(
            commits = list(
              list(sha = "abc"),
              list(sha = "def"),
              list(sha = "abc"),
              list(sha = "123")
            ),
            total_commits = 4L
          )
        )
      }
      if (source == "source2") {
        if (page == 1) {
          return(
            list(
              commits = list(list(sha = "abc"), list(sha = "def")),
              total_commits = 3L
            )
          )
        }
        return(list(commits = list()))
      }
      if (source == "source3") {
        if (page == 1) {
          return(
            list(
              commits = list(list(sha = "abc"), list(sha = "def")),
              total_commits = 3L
            )
          )
        }
        return(list(commits = list(list(sha = "ghi"))))
      }
      return(list(commits = list(), total_commits = 0L))
    }
  )
  expect_equal(FetchMergeCommitSHAs("source", "target"), c("123", "abc", "def"))
  expect_equal(FetchMergeCommitSHAs("source2", "target"), c("abc", "def"))
  expect_equal(
    FetchMergeCommitSHAs("source3", "target"),
    c("abc", "def", "ghi")
  )
  expect_equal(FetchMergeCommitSHAs("other", "target"), character())
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
    FetchAllMergePRNumbers(character()),
    integer()
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
    integer()
  )
})

test_that("BuildCommitPRQuery builds the expected query (#133)", {
  expect_snapshot({
    BuildCommitPRQuery(c("sha1", "sha2"))
  })
})

test_that("FetchAllMergeIssueNumbers returns unique, sorted issue numbers (#149)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = 5:1,
        CloserType = c(
          "PullRequest",
          "PullRequest",
          "Commit",
          "Commit",
          "PullRequest"
        ),
        CloserSHA = c(NA, NA, "sha1", "sha2", NA),
        CloserPRNumber = c(101, 102, NA, NA, 103)
      )
    }
  )
  expect_equal(
    FetchAllMergeIssueNumbers(c(101, 102), c("sha1")),
    3:5
  )
  expect_equal(
    FetchAllMergeIssueNumbers(integer(), character()),
    integer()
  )
})
