test_that("MapTestsToCommits adds commit SHAs for each test (#53, #201)", {
  dfFileTests <- tibble::tibble(
    Test = c("First test", "Second test", "Third test"),
    File = c("test-example.R", "test-example.R", "test-other.R"),
    LineStart = c(1L, 10L, 5L),
    LineEnd = c(5L, 15L, 8L),
    Issues = list(integer(), integer(), integer()),
    TaggedNoIssue = c(FALSE, FALSE, FALSE)
  )
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      if (grepl("test-example.R$", strFilePath)) {
        list(
          hunks = list(
            list(
              final_commit_id = "abc123",
              final_start_line_number = 1L,
              lines_in_hunk = 11L
            ),
            list(
              final_commit_id = "def456",
              final_start_line_number = 12L,
              lines_in_hunk = 7L
            )
          )
        )
      } else {
        list(
          hunks = list(
            list(
              final_commit_id = "ghi789",
              final_start_line_number = 1L,
              lines_in_hunk = 20L
            )
          )
        )
      }
    },
    GetRelativePackagePath = function(strFilePath, envCall) strFilePath
  )
  dfResult <- MapTestsToCommits(dfFileTests)
  dfExpected <- tibble::tibble(
    Test = c("First test", "Second test", "Third test"),
    File = c("test-example.R", "test-example.R", "test-other.R"),
    LineStart = c(1L, 10L, 5L),
    LineEnd = c(5L, 15L, 8L),
    Issues = list(integer(), integer(), integer()),
    TaggedNoIssue = c(FALSE, FALSE, FALSE),
    Commits = list("abc123", c("abc123", "def456"), "ghi789")
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestsToCommits handles tests with no commits (#noissue)", {
  dfFileTests <- tibble::tibble(
    Test = "Test",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    TaggedNoIssue = FALSE
  )
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      list(hunks = list())
    }
  )
  dfResult <- MapTestsToCommits(dfFileTests)
  dfExpected <- tibble::tibble(
    Test = "Test",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    TaggedNoIssue = FALSE,
    Commits = list(character())
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestsToCommits handles empty input (#noissue)", {
  dfFileTests <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = list(),
    TaggedNoIssue = logical()
  )
  dfResult <- MapTestsToCommits(dfFileTests)
  dfExpected <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = list(),
    TaggedNoIssue = logical(),
    Commits = list()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestsToCommits deduplicates commits within a test (#noissue)", {
  dfFileTests <- tibble::tibble(
    Test = "Test spanning multiple hunks from same commit",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 20L,
    Issues = list(integer()),
    TaggedNoIssue = FALSE
  )
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      list(
        hunks = list(
          list(
            final_commit_id = "abc123",
            final_start_line_number = 1L,
            lines_in_hunk = 10L
          ),
          list(
            final_commit_id = "def456",
            final_start_line_number = 11L,
            lines_in_hunk = 5L
          ),
          list(
            final_commit_id = "abc123",
            final_start_line_number = 16L,
            lines_in_hunk = 5L
          )
        )
      )
    },
    GetRelativePackagePath = function(strFilePath, envCall) strFilePath
  )
  dfResult <- MapTestsToCommits(dfFileTests)
  dfExpected <- tibble::tibble(
    Test = "Test spanning multiple hunks from same commit",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 20L,
    Issues = list(integer()),
    TaggedNoIssue = FALSE,
    Commits = list(c("abc123", "def456"))
  )
  expect_identical(dfResult, dfExpected)
})

test_that("BlameFile returns structured blame data (#noissue)", {
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      list(
        hunks = list(
          list(
            final_commit_id = "abc123",
            final_start_line_number = 1L,
            lines_in_hunk = 8L
          ),
          list(
            final_commit_id = "def456",
            final_start_line_number = 9L,
            lines_in_hunk = 10L
          )
        )
      )
    },
    GetRelativePackagePath = function(strFilePath, envCall) strFilePath
  )
  dfResult <- BlameFile("test-fake.R")
  dfExpected <- tibble::tibble(
    File = "test-fake.R",
    Line = 1:18,
    Commits = as.list(c(rep("abc123", 8), rep("def456", 10)))
  )
  expect_identical(dfResult, dfExpected)
})

test_that("BlameFile works with no blame data (#noissue)", {
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      list(hunks = list())
    }
  )
  dfResult <- BlameFile("test-fake.R")
  dfExpected <- tibble::tibble(
    File = character(),
    Line = integer(),
    Commits = list()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("GetRelativePackagePath finds the relative path (#201)", {
  skip_if(is_checking(), "Catch this one in the qcthat checks.")
  expect_equal(
    GetRelativePackagePath(test_path("test-MapTestsToCommits.R")) |>
      stringr::str_remove("^qcthat-") |>
      fs::path(),
    fs::path("tests/testthat/test-MapTestsToCommits.R")
  )
})
