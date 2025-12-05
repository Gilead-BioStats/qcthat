test_that("GuessPRNumber delegates to its sub-functions (#84)", {
  local_mocked_bindings(
    GetGHAPRNumber = function(...) 42L,
    FetchRefPRNumber = function(...) 21L
  )
  expect_equal(GuessPRNumber(), 42L)
  local_mocked_bindings(
    GetGHAPRNumber = function(...) NULL,
    FetchRefPRNumber = function(...) 21L
  )
  expect_equal(GuessPRNumber(), 21L)
})

test_that("GetGHAPRNumber detects PR number for a GHA", {
  withr::local_envvar(list(
    GITHUB_EVENT_NAME = "",
    GITHUB_REF_NAME = ""
  ))
  expect_null(GetGHAPRNumber())
  withr::local_envvar(list(
    GITHUB_EVENT_NAME = "pull_request",
    GITHUB_REF_NAME = ""
  ))
  expect_null(GetGHAPRNumber())
  withr::local_envvar(list(
    GITHUB_EVENT_NAME = "",
    GITHUB_REF_NAME = "123/merge"
  ))
  expect_null(GetGHAPRNumber())
  withr::local_envvar(list(
    GITHUB_EVENT_NAME = "pull_request",
    GITHUB_REF_NAME = "123/merge"
  ))
  expect_equal(GetGHAPRNumber(), 123L)
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
