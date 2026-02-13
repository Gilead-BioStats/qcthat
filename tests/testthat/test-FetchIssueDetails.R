test_that("FetchIssueDetails fetches issue details (#53)", {
  local_mocked_bindings(
    CallGHAPI = function(endpoint, issue_number, ...) {
      if (issue_number == 1L) {
        list(number = 1L, title = "First issue", body = "Body of first.")
      } else if (issue_number == 2L) {
        list(number = 2L, title = "Second issue", body = "Body of second.")
      } else {
        list(number = 3L, title = "Third issue", body = NULL)
      }
    }
  )
  dfResult <- FetchIssueDetails(1:3)
  dfExpected <- tibble::tibble(
    Issue = 1:3,
    Title = c("First issue", "Second issue", "Third issue"),
    Body = c("Body of first.", "Body of second.", NA_character_)
  )
  expect_identical(dfResult, dfExpected)
})

test_that("FetchIssueDetails handles empty input (#53)", {
  dfResult <- FetchIssueDetails(integer())
  dfExpected <- tibble::tibble(
    Issue = integer(),
    Title = character(),
    Body = character()
  )
  expect_identical(dfResult, dfExpected)
})

test_that("FetchIssueDetails deduplicates API calls but preserves order (#53)", {
  intCallCount <- 0L
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, ..., issue_number = NULL) {
      intCallCount <<- intCallCount + 1L
      list(
        number = issue_number,
        title = paste("Issue", issue_number),
        body = paste("Body", issue_number)
      )
    }
  )
  dfResult <- FetchIssueDetails(c(5L, 2L, 8L, 2L, 1L))
  expect_equal(intCallCount, 4L)
  expect_equal(dfResult$Issue, c(5L, 2L, 8L, 2L, 1L))
})

test_that("FetchIssueDetails passes GitHub parameters (#53)", {
  local_mocked_bindings(
    CallGHAPI = function(
      endpoint,
      strOwner = "default",
      strRepo = "default",
      strGHToken = "default",
      ...
    ) {
      expect_equal(strOwner, "testowner")
      expect_equal(strRepo, "testrepo")
      expect_equal(strGHToken, "testtoken")
      list(number = 1L, title = "Test", body = "Body")
    }
  )
  dfResult <- FetchIssueDetails(
    1L,
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_equal(nrow(dfResult), 1L)
})
