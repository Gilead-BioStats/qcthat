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
    FetchRawRepoPRs = function(...) {
      list(
        list(number = 10L, merged = TRUE, merge_commit_sha = "merge-sha-10"),
        list(number = 20L, merged = TRUE, merge_commit_sha = "merge-sha-20")
      )
    },
    FetchAllMergeCommitSHAsLocal = function(chrMergeSHAs, strPkgRoot) {
      list(
        c("commit1", "commit2", "commit3"),
        c("commit4", "commit5")
      )
    }
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
    FetchRawRepoPRs = function(...) {
      list(list(number = 15L, merged = TRUE, merge_commit_sha = "merge-sha-15"))
    },
    FetchAllMergeCommitSHAsLocal = function(...) list(c("commit1", "commit2"))
  )
  dfResult <- MapRepoIssuesToCommits()
  dfExpected <- tibble::tibble(
    Issue = c(1L, 2L, 3L),
    Commits = list("abc123", c("commit1", "commit2"), "ghi789")
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapRepoIssuesToCommits handles empty input (#200)", {
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
    Commits = vctrs::list_of(.ptype = character())
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
      list(list(number = 10L, merged = TRUE, merge_commit_sha = "merge-sha-10"))
    },
    FetchAllMergeCommitSHAsLocal = function(chrMergeSHAs, strPkgRoot) {
      list("commit1")
    }
  )
  dfResult <- MapRepoIssuesToCommits(
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_equal(nrow(dfResult), 1L)
})
