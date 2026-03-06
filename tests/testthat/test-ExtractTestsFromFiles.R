test_that("ExtractTestsFromFiles parses tests and issues from test dirs (#52, #201, #257)", {
  skip_if_not_installed("astgrepr")
  strTestDir <- test_path("fixtures", "testFiles")
  dfResult <- ExtractTestsFromFiles(strTestDir)
  dfExpected <- tibble::tibble(
    Test = c(
      '"First test with one issue (#3)"',
      '"Second test with no issue (#noissue)"',
      '"Test with multiple issues (#10, #9)"',
      '"Outer test (#1)"',
      "'Test with \"quotes\" and \\'apostrophes\\' (#5)'",
      '"Test with (parentheses) and [brackets] (#6)"',
      '"No spaces (#1,#2)"'
    ),
    LineStart = c(3L, 7L, 11L, 16L, 3L, 7L, 11L),
    LineEnd = c(5L, 9L, 14L, 23L, 5L, 9L, 13L),
    Issues = list(3L, integer(), 9:10, 1L, 5L, 6L, 1:2),
    TaggedNoIssue = c(FALSE, TRUE, rep(FALSE, 5))
  )
  expect_identical(
    fs::path_file(dfResult$File),
    c(rep("test-example1.R", 4), rep("test-example2.R", 3))
  )
  dfResult$File <- NULL
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
    Issues = vctrs::list_of(.ptype = integer()),
    TaggedNoIssue = logical()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("FindTests finds tests using testthat:: namespace prefix (#247, #257)", {
  skip_if_not_installed("astgrepr")
  chrLines <- c(
    "# comment",
    'testthat::test_that("Test with namespace prefix", {',
    "  expect_true(TRUE)",
    "})"
  )
  lResult <- FindTests(chrLines)
  expect_length(lResult, 1L)
  expect_equal(lResult[[1]]$Test, '"Test with namespace prefix"')
  expect_equal(lResult[[1]]$LineStart, 2L)
  expect_equal(lResult[[1]]$LineEnd, 4L)
})
