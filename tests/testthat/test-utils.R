test_that("AsExpectedDF works with empty dfs", {
  dfShape <- data.frame(
    A = integer(),
    B = character(),
    C = logical()
  )
  dfExpected <- structure(
    dfShape,
    class = c("my_expected_class", "data.frame")
  )
  test_result <- AsExpectedDF(
    data.frame(),
    dfShape,
    "my_expected_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_class", "data.frame"),
    exact = TRUE
  )
  expect_equal(test_result, dfExpected)
})

test_that("AsExpectedDF works with non-empty dfs", {
  dfShape <- data.frame(
    A = integer(),
    B = character(),
    C = logical()
  )
  dfGiven <- data.frame(
    A = 1:5,
    B = letters[1:5],
    C = c(TRUE, FALSE, TRUE, FALSE, TRUE)
  )
  dfExpected <- structure(
    dfGiven,
    class = c("my_expected_class", "data.frame")
  )
  test_result <- AsExpectedDF(
    dfGiven,
    dfShape,
    "my_expected_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_class", "data.frame"),
    exact = TRUE
  )
  expect_equal(test_result, dfExpected)
})
