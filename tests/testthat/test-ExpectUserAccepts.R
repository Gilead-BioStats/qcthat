test_that("ExpectUserAccepts returns the input strDescription", {
  local_mocked_bindings(
    OnCran = function() TRUE
  )
  strDescription <- "The thing renders"
  chrChecks <- c("check1", "check2")
  result <- ExpectUserAccepts(
    strDescription,
    intIssue = 12L,
    chrChecks = chrChecks
  )
  expect_identical(result, strDescription)
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
      strDescription = "The thing renders",
      intIssue = 12L,
      chrChecks = c("check1", "check2")
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
        strDescription = "The thing renders",
        intIssue = 12L,
        chrChecks = c("check1", "check2"),
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
  strDescription <- "The thing renders"
  result <- ExpectUserAccepts(
    strDescription = strDescription,
    intIssue = 12L,
    chrChecks = chrChecks
  )
  expect_identical(result, strDescription)
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
