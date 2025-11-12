test_that("PrepareGQLQuery constructs a query (#84)", {
  strVar <- "test_value"
  test_result <- PrepareGQLQuery(
    "line 1: <strVar>",
    "line 2",
    strVar = strVar
  )
  expect_snapshot(test_result)
})

test_that("PrepareGQLQuery works with different delimiters (#84)", {
  strVar <- "test_value"
  test_result <- PrepareGQLQuery(
    "line 1: {{strVar}}",
    "line 2",
    strOpen = "{{",
    strClose = "}}",
    strVar = strVar
  )
  expect_snapshot(test_result)
})

test_that("GQLWrapper wraps a query correctly (#84)", {
  test_result <- GQLWrapper(
    strQuery = "sub-query",
    strOwner = "owner",
    strRepo = "repo"
  )
  expect_snapshot(test_result)
})
