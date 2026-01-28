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

test_that("GetGHAPRNumber returns NULL for bad arg (#84, #163)", {
  expect_null(GetGHAPRNumber(NULL))
  expect_null(GetGHAPRNumber(letters))
  expect_null(GetGHAPRNumber(list()))
})

test_that("GetGHAPRNumber extracts PR number from lGHEventPayload when available (#84, #163)", {
  expect_equal(
    GetGHAPRNumber(list(pull_request = list(number = 42))),
    42
  )
  expect_equal(
    GetGHAPRNumber(list(inputs = list(pr = 42))),
    42
  )
})

test_that("GetGHAPRNumber returns NULL for bad extracted PR number (#84, #163)", {
  expect_null(GetGHAPRNumber(list(pull_request = list(number = "a"))))
})

test_that("FetchRefPRNumber fetches PR number for a branch (#84, #132)", {
  local_mocked_bindings(
    FetchRepoPRs = function(...) {
      tibble::tibble(
        PR = c(20L, 25L, 30L, 35L, 40L, 41L),
        HeadRef = c(
          "other-branch",
          "feature-branch",
          "another-branch",
          "other-branch",
          "double-pr",
          "double-pr"
        ),
        State = c("open", "open", "open", "open", "closed", "open"),
        CreatedAt = as.Date(1:6, origin = "2026-01-01", tz = "UTC")
      )
    }
  )
  expect_equal(FetchRefPRNumber("feature-branch"), 25L)
  expect_equal(FetchRefPRNumber("no-branch"), integer())
  expect_warning(
    {
      expect_equal(FetchRefPRNumber("other-branch"), 35L)
    },
    class = "qcthat-warning-multiple_prs"
  )
  expect_warning(
    {
      expect_equal(FetchRefPRNumber("double-pr"), 41L)
    },
    class = "qcthat-warning-multiple_prs"
  )
})

test_that("ChooseRefPRNumber() deals with corner cases (#132)", {
  expected_error_class <- "qcthat-error-invalid_pr_dataframe"
  expect_error(
    {
      ChooseRefPRNumber(NULL, "ref")
    },
    class = expected_error_class
  )
  expect_error(
    {
      ChooseRefPRNumber(data.frame(), "ref")
    },
    class = expected_error_class
  )
  expect_error(
    {
      ChooseRefPRNumber(mtcars, "ref")
    },
    class = expected_error_class
  )
})
