test_that("FetchMergeCommitSHAs returns unique, sorted SHAs (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(
        commits = list(
          list(sha = "abc"),
          list(sha = "def"),
          list(sha = "abc"),
          list(sha = "123")
        )
      )
    }
  )
  expect_equal(FetchMergeCommitSHAs("source", "target"), c("123", "abc", "def"))
})

test_that("FetchMergeCommitSHAs returns empty vector for no commits (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(commits = list())
    }
  )
  expect_equal(FetchMergeCommitSHAs("source", "target"), character(0))
})
