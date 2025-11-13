test_that("PrepareGQLQuery constructs a query (#84)", {
  expect_snapshot({
    PrepareGQLQuery(
      "line 1: <strVar>",
      "line 2",
      strVar = "test_value"
    )
  })
  expect_snapshot({
    PrepareGQLQuery(
      "line 1: {{strVar}}",
      "line 2",
      strOpen = "{{",
      strClose = "}}",
      strVar = "test_value"
    )
  })
})

test_that("GQLWrapper wraps a query correctly (#84)", {
  expect_snapshot({
    GQLWrapper(
      strQuery = "sub-query",
      strOwner = "owner",
      strRepo = "repo"
    )
  })
})
