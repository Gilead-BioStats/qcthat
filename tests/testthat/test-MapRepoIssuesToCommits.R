test_that("MapRepoIssuesToCommits handles commit closers (#53)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L),
        CloserType = c("Commit", "Commit"),
        CloserSHA = c("abc123", "def456"),
        CloserPRNumber = c(NA_integer_, NA_integer_)
      )
    },
    FetchRawRepoPRs = function(...) NULL
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = c(1L, 2L),
    Commits = list("abc123", "def456")
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits handles PR closers (#53)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L),
        CloserType = c("PullRequest", "PullRequest"),
        CloserSHA = c(NA_character_, NA_character_),
        CloserPRNumber = c(10L, 20L)
      )
    },
    FetchPRRefs = function(intPRNumber, ...) {
      if (intPRNumber == 10L) {
        c(strSourceRef = "pr-10-head", strTargetRef = "main")
      } else {
        c(strSourceRef = "pr-20-head", strTargetRef = "main")
      }
    },
    FetchMergeCommitSHAs = function(strSourceRef, strTargetRef, ...) {
      if (strSourceRef == "pr-10-head") {
        c("commit1", "commit2", "commit3")
      } else {
        c("commit4", "commit5")
      }
    },
    FetchRawRepoPRs = function(...) NULL
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = c(1L, 2L),
    Commits = list(c("commit1", "commit2", "commit3"), c("commit4", "commit5"))
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits handles mixed closers (#53)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L, 3L),
        CloserType = c("Commit", "PullRequest", "Commit"),
        CloserSHA = c("abc123", NA_character_, "ghi789"),
        CloserPRNumber = c(NA_integer_, 15L, NA_integer_)
      )
    },
    FetchPRRefs = function(intPRNumber, ...) {
      c(strSourceRef = "pr-15-head", strTargetRef = "main")
    },
    FetchMergeCommitSHAs = function(strSourceRef, strTargetRef, ...) {
      c("commit1", "commit2")
    },
    FetchRawRepoPRs = function(...) NULL
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = c(1L, 2L, 3L),
    Commits = list("abc123", c("commit1", "commit2"), "ghi789")
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits handles empty input (#noissue)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = integer(),
        CloserType = character(),
        CloserSHA = character(),
        CloserPRNumber = integer()
      )
    }
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = integer(),
    Commits = list()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits handles issues with no closer info (#noissue)", {
  # This shouldn't happen in practice since FetchRepoIssueClosers filters these
  # out, but we should handle it gracefully
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = 1L,
        CloserType = NA_character_,
        CloserSHA = NA_character_,
        CloserPRNumber = NA_integer_
      )
    },
    FetchRawRepoPRs = function(...) NULL
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = 1L,
    Commits = list(NA_character_)
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits passes GitHub parameters to other internal functions (#noissue)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(strOwner, strRepo, strGHToken) {
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      tibble::tibble(
        Issue = 1L,
        CloserType = "PullRequest",
        CloserSHA = NA_character_,
        CloserPRNumber = 10L
      )
    },
    FetchRawRepoPRs = function(...) {
      NULL
    },
    FetchPRRefs = function(intPRNumber, strOwner, strRepo, strGHToken, ...) {
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      c(strSourceRef = "head", strTargetRef = "base")
    },
    FetchMergeCommitSHAs = function(
      strSourceRef,
      strTargetRef,
      strOwner,
      strRepo,
      strGHToken,
      ...
    ) {
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      "commit1"
    }
  )
  dfResult <- MapRepoIssuesToCommits(
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_equal(nrow(dfResult), 1L)
})
