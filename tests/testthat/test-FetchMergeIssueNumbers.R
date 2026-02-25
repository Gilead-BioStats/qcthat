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

test_that("BuildCommitPRQuery builds the expected query (#133)", {
  expect_snapshot({
    BuildCommitPRQuery(c("sha1", "sha2"))
  })
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

test_that("BuildPRIssuesQuery builds the expected query (#133)", {
  expect_snapshot({
    BuildPRIssuesQuery(c("sha1", "sha2"))
  })
})

test_that("FetchAllPRIssueNumbers returns unique, sorted issue numbers (#133)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        pr101 = list(
          issues = list(
            nodes = list(list(number = 3), list(number = 1))
          )
        ),
        pr102 = list(
          issues = list(
            nodes = list(list(number = 2), list(number = 3))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllPRIssueNumbers(c(101, 102)),
    1:3
  )
  expect_equal(
    FetchAllPRIssueNumbers(integer()),
    integer()
  )
})

test_that("FetchMergeIssueClosers returns unique, sorted issue numbers (#149)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = 1:5,
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
    FetchMergeIssueClosers(c(101, 102), c("sha1")),
    1:3
  )
  expect_equal(
    FetchMergeIssueClosers(integer(), character()),
    integer()
  )
})

test_that("FetchMergeIssueNumbers makes the expected calls (#noissue)", {
  local_mocked_bindings(
    FetchMergeCommitSHAs = function(strSourceRef, strTargetRef, ...) {
      expect_equal(strSourceRef, "source")
      expect_equal(strTargetRef, "target")
      c("sha1", "sha2")
    },
    FetchAllMergePRNumbers = function(chrCommitSHAs, ...) {
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
      101:102
    },
    FetchAllPRIssueNumbers = function(...) integer(),
    FetchMergeIssueClosers = function(intPRNumbers, chrCommitSHAs, ...) {
      expect_equal(intPRNumbers, 101:102)
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
      1:3
    }
  )
  expect_equal(
    FetchMergeIssueNumbers("source", "target"),
    1:3
  )
})
