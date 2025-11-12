test_that("FetchAllPRIssueNumbers returns unique, sorted issue numbers (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        pr12 = list(
          closingIssuesReferences = list(
            nodes = list(list(number = 1), list(number = 2))
          )
        ),
        pr34 = list(
          closingIssuesReferences = list(
            nodes = list(list(number = 2), list(number = 3))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllPRIssueNumbers(c(12, 34)),
    1:3
  )
})

test_that("FetchAllPRIssueNumbers returns empty vector for no PRs (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) stop("FetchGQL should not be called")
  )
  expect_equal(FetchAllPRIssueNumbers(integer(0)), integer(0))
})

test_that("FetchAllPRIssueNumbers returns empty vector for no matching issues (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(pr12 = list(closingIssuesReferences = list(nodes = list())))
    }
  )
  expect_equal(FetchAllPRIssueNumbers(12), integer(0))
})

test_that("BuildPRIssuesQuery creates the correct sub-query (#84)", {
  expect_snapshot({
    BuildPRIssuesQuery(123)
  })
})
