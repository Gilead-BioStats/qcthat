# Test file 1 with various test patterns

test_that("First test with one issue (#3)", {
  expect_true(TRUE)
})

test_that("Second test with no issue (#noissue)", {
  expect_equal(1, 1)
})

test_that("Test with multiple issues (#10, #9)", {
  expect_true(TRUE)
  expect_false(FALSE)
})

test_that("Outer test (#1)", {
  expect_true(TRUE)

  # This should not be parsed as a separate test:
  # test_that("Inner test (#2)", {
  #   expect_true(TRUE)
  # })
})
