test_that("AsExpected works with empty dfs (#39)", {
  dfShape <- data.frame(
    A = integer(),
    B = character(),
    C = logical()
  )
  dfExpected <- structure(
    dfShape,
    class = c("my_expected_class", "qcthat_Object", "data.frame")
  )
  test_result <- AsExpected(
    data.frame(),
    dfShape,
    "my_expected_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_class", "qcthat_Object", "data.frame"),
    exact = TRUE
  )
  expect_equal(test_result, dfExpected)
})

test_that("AsExpected works with non-empty dfs (#39)", {
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
    class = c("my_expected_class", "qcthat_Object", "data.frame")
  )
  test_result <- AsExpected(
    dfGiven,
    dfShape,
    "my_expected_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_class", "qcthat_Object", "data.frame"),
    exact = TRUE
  )
  expect_equal(test_result, dfExpected)
})

test_that("AsExpectedFlat works with NULL (#39)", {
  lShape <- list(A = integer())
  lExpected <- structure(
    lShape,
    class = c("my_expected_flat_class", "qcthat_Object", "list")
  )
  test_result <- AsExpectedFlat(NULL, lShape, "my_expected_flat_class")
  expect_s3_class(
    test_result,
    c("my_expected_flat_class", "qcthat_Object", "list"),
    exact = TRUE
  )
  expect_equal(test_result, lExpected)
})

test_that("AsExpectedFlat works with empty lists (#39)", {
  lShape <- list(
    A = integer(),
    B = character(),
    C = logical()
  )
  lExpected <- structure(
    lShape,
    class = c("my_expected_flat_class", "qcthat_Object", "list")
  )
  test_result <- AsExpectedFlat(
    list(),
    lShape,
    "my_expected_flat_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_flat_class", "qcthat_Object", "list"),
    exact = TRUE
  )
  expect_equal(test_result, lExpected)
})

test_that("AsExpectedFlat works with non-empty data.frames (#39)", {
  dfGiven <- data.frame(
    A = 1,
    B = "a",
    C = TRUE
  )
  lShape <- list(
    A = integer(),
    B = character(),
    C = logical()
  )
  lExpected <- structure(
    list(
      A = 1,
      B = "a",
      C = TRUE
    ),
    class = c("my_expected_flat_class", "qcthat_Object", "list")
  )
  test_result <- AsExpectedFlat(
    dfGiven,
    lShape,
    "my_expected_flat_class"
  )
  expect_s3_class(
    test_result,
    c("my_expected_flat_class", "qcthat_Object", "list"),
    exact = TRUE
  )
  expect_equal(test_result, lExpected)
})

test_that("AsRowDFList splits and transforms correctly (#39)", {
  dfInput <- data.frame(
    X = 1:3,
    Y = letters[1:3],
    Z = c(TRUE, FALSE, TRUE)
  )
  fnTransform <- function(dfRow) {
    dfRow$Y <- toupper(dfRow$Y)
    return(dfRow)
  }
  test_result <- AsRowDFList(dfInput, fnTransform)
  expect_equal(length(test_result), 3)
  for (i in seq_along(test_result)) {
    expect_s3_class(test_result[[i]], "data.frame")
    expect_equal(nrow(test_result[[i]]), 1)
    expect_equal(test_result[[i]]$X, dfInput$X[i])
    expect_equal(test_result[[i]]$Y, toupper(dfInput$Y[i]))
    expect_equal(test_result[[i]]$Z, dfInput$Z[i])
  }
})

test_that("CountNonNA counts unique non-NA values correctly (#39)", {
  vecInput1 <- c(1, 2, 2, NA, 3, NA, 1)
  expect_equal(CountNonNA(vecInput1), 3)

  vecInput2 <- c(NA, NA, NA)
  expect_equal(CountNonNA(vecInput2), 0)

  vecInput3 <- c("a", "b", "a", "c", NA, "b")
  expect_equal(CountNonNA(vecInput3), 3)

  vecInput4 <- double()
  expect_equal(CountNonNA(vecInput4), 0)
})

test_that("SimplePluralize returns correct singular/plural forms (#39)", {
  expect_equal(SimplePluralize("cat", 1), "cat")
  expect_equal(SimplePluralize("cat", 2), "cats")
  expect_equal(SimplePluralize("dog", 0), "dogs")
})

test_that("NullIfEmpty returns NULL for empty inputs (#34)", {
  expect_null(NullIfEmpty(integer()))
  expect_null(NullIfEmpty(character()))
  expect_null(NullIfEmpty(list()))
  expect_null(NullIfEmpty(NULL))
  expect_equal(NullIfEmpty(c(1, 2, 3)), c(1, 2, 3))
  expect_equal(NullIfEmpty("hello"), "hello")
  expect_equal(NullIfEmpty(list(a = 1)), list(a = 1))
})

test_that("CompletelyFlatten flattens, unnames, and uniquifies nested listed (#84)", {
  nested_list <- list(a = 1, b = list(c = 2, d = list(e = 3)), f = 3)
  expect_equal(CompletelyFlatten(nested_list), 1:3)
})

test_that("HaveString finds strings in lists of characters (#67)", {
  list_with_strings <- list(
    c("apple", "banana"),
    c("cherry", "date"),
    c("date", "apple")
  )
  expect_identical(
    HaveString(list_with_strings, "apple"),
    c(TRUE, FALSE, TRUE)
  )
  expect_identical(
    HaveString(list_with_strings, "banana"),
    c(TRUE, FALSE, FALSE)
  )
  expect_identical(
    HaveString(list_with_strings, "date"),
    c(FALSE, TRUE, TRUE)
  )
})
