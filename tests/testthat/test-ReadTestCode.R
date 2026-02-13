test_that("ReadTestCode reads test code from file (#53)", {
  chrResult <- ReadTestCode(
    strFile = "test-example1.R",
    intLineStart = 3L,
    intLineEnd = 5L,
    strTestDir = test_path("fixtures", "testFiles")
  )
  chrExpected <- c(
    "test_that(\"First test with one issue (#3)\", {",
    "  expect_true(TRUE)",
    "})"
  )
  expect_equal(chrResult, chrExpected)
})

test_that("ReadTestCode fails for invalid ranges (#53)", {
  expect_error(
    ReadTestCode(
      strFile = "test-example1.R",
      intLineStart = 100L,
      intLineEnd = 200L,
      strTestDir = test_path("fixtures", "testFiles")
    ),
    regexp = "only contains \\d+ lines",
    class = "qcthat-error-invalid_file_lines"
  )
  expect_error(
    ReadTestCode(
      strFile = "test-example1.R",
      intLineStart = 10L,
      intLineEnd = 5L,
      strTestDir = test_path("fixtures", "testFiles")
    ),
    regexp = "must be larger than",
    class = "qcthat-error-invalid_file_lines"
  )
})

test_that("ReadTestCode fails for bad path (#53)", {
  expect_error(
    ReadTestCode(
      strFile = "test-does_not_exist.R",
      intLineStart = 1L,
      intLineEnd = 2L,
      strTestDir = test_path("fixtures", "testFiles")
    ),
    regexp = "must exist in",
    class = "qcthat-error-invalid_file_path"
  )
})
