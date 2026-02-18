test_that("ExtractTestsFromFiles parses tests and issues from test dirs (#52, #201)", {
  skip_if(is_checking(), "Catch this one in the qcthat checks.")
  strTestDir <- test_path("fixtures", "testFiles")
  dfResult <- ExtractTestsFromFiles(strTestDir)
  dfExpected <- tibble::tibble(
    Test = c(
      "First test with one issue (#3)",
      "Second test with no issue (#noissue)",
      "Test with multiple issues (#10, #9)",
      "Outer test (#1)",
      'Test with "quotes" and \'apostrophes\' (#5)',
      "Test with (parentheses) and [brackets] (#6)",
      "No spaces (#1,#2)"
    ),
    File = fs::path(
      "tests/testthat/fixtures/testFiles",
      c(rep("test-example1.R", 4), rep("test-example2.R", 3))
    ),
    LineStart = c(3L, 7L, 11L, 16L, 3L, 7L, 11L),
    LineEnd = c(5L, 9L, 14L, 23L, 5L, 9L, 13L),
    Issues = list(3L, integer(), 9:10, 1L, 5L, 6L, 1:2),
    TaggedNoIssue = c(FALSE, TRUE, rep(FALSE, 5))
  )
  # Deal with slight difference during certain CI.
  dfResult$File <- stringr::str_remove(dfResult$File, "^qcthat-") |>
    stringr::str_remove("^check/qcthat\\.Rcheck/") |>
    fs::path()
  expect_identical(dfResult, dfExpected)
})

test_that("ExtractTestsFromFiles returns an empty tibble with the expected shape for empty directories (#noissue)", {
  local_mocked_bindings(
    ListTestFiles = function(strTestDir) {
      expect_equal(strTestDir, "empty/dir")
      character()
    }
  )
  dfResult <- ExtractTestsFromFiles("empty/dir")
  dfExpected <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = list(),
    TaggedNoIssue = logical()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("ParseTest handles corner cases (#noissue)", {
  expect_null(
    ParseTest(
      chrTestLines = "mean(1:10)",
      intTestStart = 1
    )
  )
  expect_null(
    ParseTest(
      chrTestLines = "test_that(stop())",
      intTestStart = 1
    )
  )
  expect_null(
    ParseTest(
      chrTestLines = 'test_that("This will fail to parse because it is incomplete (#99)", {',
      intTestStart = 1
    )
  )
})
