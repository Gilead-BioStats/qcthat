test_that("PrepareTestIssueContext enriches test data (#53)", {
  local_mocked_bindings(
    MapTestFilesToPotentialIssues = function(
      strTestDir,
      strOwner,
      strRepo,
      strGHToken
    ) {
      expect_equal(strTestDir, "tests/testthat")
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(1L, integer()),
        PotentialIssues = list(c(1L, 2L), 2L)
      )
    },
    FetchIssueDetails = function(intIssues, ...) {
      tibble::tibble(
        Issue = intIssues,
        Title = paste("Issue", intIssues),
        Body = paste("Body", intIssues)
      )
    },
    ReadTestCode = function(strFile, intLineStart, intLineEnd, strTestDir) {
      if (intLineStart == 1L) {
        c("test_that(\"Test 1\", {", "  expect_true(TRUE)", "})")
      } else {
        c("test_that(\"Test 2\", {", "  expect_equal(1, 1)", "})")
      }
    }
  )
  dfResult <- PrepareTestIssueContext()
  dfExpected <- tibble::tibble(
    Test = c("Test 1", "Test 2"),
    File = c("test-example.R", "test-example.R"),
    LineStart = c(1L, 5L),
    LineEnd = c(3L, 7L),
    Issues = list(1L, integer()),
    PotentialIssueDetails = list(
      tibble::tibble(
        Issue = c(1L, 2L),
        Title = c("Issue 1", "Issue 2"),
        Body = c("Body 1", "Body 2")
      ),
      tibble::tibble(
        Issue = 2L,
        Title = "Issue 2",
        Body = "Body 2"
      )
    ),
    TestCode = list(
      c("test_that(\"Test 1\", {", "  expect_true(TRUE)", "})"),
      c("test_that(\"Test 2\", {", "  expect_equal(1, 1)", "})")
    )
  )
  expect_identical(dfResult, dfExpected)
})

test_that("PrepareTestIssueContext handles empty input (#53)", {
  local_mocked_bindings(
    MapTestFilesToPotentialIssues = function(
      strTestDir,
      strOwner,
      strRepo,
      strGHToken
    ) {
      tibble::tibble(
        Test = character(),
        File = character(),
        LineStart = integer(),
        LineEnd = integer(),
        Issues = list(),
        PotentialIssues = list()
      )
    }
  )
  expect_no_error({
    dfResult <- PrepareTestIssueContext()
  })
  dfExpected <- tibble::tibble(
    Test = character(),
    File = character(),
    Issues = list(),
    PotentialIssueDetails = list(),
    TestCode = list(),
    LineStart = integer(),
    LineEnd = integer()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("PrepareTestIssueContext passes parameters (#53)", {
  local_mocked_bindings(
    MapTestFilesToPotentialIssues = function(
      strTestDir,
      strOwner,
      strRepo,
      strGHToken
    ) {
      expect_equal(strTestDir, "custom/test/dir")
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      tibble::tibble(
        Test = "Test",
        File = "test-example.R",
        LineStart = 1L,
        LineEnd = 2L,
        Issues = list(integer()),
        PotentialIssues = list(1L)
      )
    },
    FetchIssueDetails = function(intIssues, strOwner, strRepo, strGHToken) {
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      tibble::tibble(Issue = intIssues, Title = "Title", Body = "Body")
    },
    ReadTestCode = function(strFile, intLineStart, intLineEnd, strTestDir) {
      expect_equal(strTestDir, "custom/test/dir")
      "test code"
    }
  )
  dfResult <- PrepareTestIssueContext(
    strTestDir = "custom/test/dir",
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_s3_class(dfResult, "tbl_df")
})
