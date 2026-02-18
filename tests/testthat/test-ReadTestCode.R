test_that("ReadTestCode reads test code from file (#53, #201)", {
  chrResult <- ReadTestCode(
    strFile = test_path("fixtures", "testFiles", "test-example1.R"),
    intLineStart = 3L,
    intLineEnd = 5L
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
      strFile = test_path("fixtures", "testFiles", "test-example1.R"),
      intLineStart = 100L,
      intLineEnd = 200L
    ),
    regexp = "only contains \\d+ lines",
    class = "qcthat-error-invalid_file_lines"
  )
  expect_error(
    ReadTestCode(
      strFile = test_path("fixtures", "testFiles", "test-example1.R"),
      intLineStart = 10L,
      intLineEnd = 5L
    ),
    regexp = "must be larger than",
    class = "qcthat-error-invalid_file_lines"
  )
})
