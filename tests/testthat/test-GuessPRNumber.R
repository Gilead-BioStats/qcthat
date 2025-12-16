test_that("GuessPRNumber delegates to its sub-functions (#84)", {
  local_mocked_bindings(
    FetchRefPRNumber = function(...) integer(0),
    FetchLatestRepoPRNumber = function(...) 42L
  )
  expect_equal(GuessPRNumber(), 42L)
  local_mocked_bindings(
    FetchRefPRNumber = function(...) 21L,
    FetchLatestRepoPRNumber = function(...) 42L
  )
  expect_equal(GuessPRNumber(), 21L)
})

test_that("FetchLatestRepoPRNumber fetches the most recently created PR (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(
        list(number = 10L, created_at = "2025-10-10T12:00:00Z"),
        list(number = 15L, created_at = "2025-10-15T12:00:00Z"),
        list(number = 12L, created_at = "2025-10-12T12:00:00Z")
      )
    }
  )
  latest_pr_number <- FetchLatestRepoPRNumber("someowner", "myrepo", "mytoken")
  expect_equal(latest_pr_number, 15L)
})

test_that("FetchLatestRepoPRNumber returns NA if no PRs (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list()
    }
  )
  latest_pr_number <- FetchLatestRepoPRNumber("someowner", "myrepo", "mytoken")
  expect_true(is.na(latest_pr_number))
})

test_that("FetchRefPRNumber fetches PR number for a branch (#84)", {
  local_mocked_bindings(
    FetchRepoPRs = function(...) {
      tibble::tibble(
        PR = c(20L, 25L, 30L, 35L),
        HeadRef = c(
          "other-branch",
          "feature-branch",
          "another-branch",
          "other-branch"
        )
      )
    }
  )
  expect_equal(FetchRefPRNumber("feature-branch"), 25L)
  expect_equal(FetchRefPRNumber("no-branch"), integer(0))
  expect_warning(
    {
      expect_equal(FetchRefPRNumber("other-branch"), integer(0))
    },
    "Multiple PRs found"
  )
})
