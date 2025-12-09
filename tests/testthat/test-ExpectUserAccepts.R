test_that("ExpectUserAccepts returns the input chrChecks", {
  local_mocked_bindings(
    OnCran = function() TRUE
  )
  chrChecks <- c("check1", "check2")
  result <- ExpectUserAccepts(
    chrChecks = chrChecks,
    intIssue = 123
  )
  expect_identical(result, chrChecks)
})

test_that("ExpectUserAccepts passes when the issue is closed", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "closed", Url = "http://example.com/issue/123")
    }
  )
  expect_success({
    ExpectUserAccepts(
      chrChecks = c("check1", "check2"),
      intIssue = 123
    )
  })
})

test_that("ExpectUserAccepts fails when the issue isn't closed and strFailureMode is 'fail'", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    }
  )
  expect_failure(
    {
      ExpectUserAccepts(
        chrChecks = c("check1", "check2"),
        intIssue = 123,
        strFailureMode = "fail"
      )
    },
    "http://example.com/issue/123"
  )
})

test_that("ExpectUserAccepts returns silently when the issue isn't closed and strFailureMode is 'ignore'", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    }
  )
  chrChecks <- c("check1", "check2")
  result <- ExpectUserAccepts(
    chrChecks = chrChecks,
    intIssue = 123
  )
  expect_identical(result, chrChecks)
})

test_that("OnCran returns FALSE when envvar unset or true (#113)", {
  withr::local_envvar(list(NOT_CRAN = ""))
  expect_false(OnCran())
  withr::local_envvar(list(NOT_CRAN = "true"))
  expect_false(OnCran())
})

test_that("OnCran returns TRUE when envvar set to false (#113)", {
  withr::local_envvar(list(NOT_CRAN = "false"))
  expect_true(OnCran())
})
