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

test_that("OnCran returns FALSE when envvar unset or true", {
  withr::local_envvar(list(NOT_CRAN = ""))
  expect_false(OnCran())
  withr::local_envvar(list(NOT_CRAN = "true"))
  expect_false(OnCran())
})

test_that("OnCran returns TRUE when envvar set to false", {
  withr::local_envvar(list(NOT_CRAN = "false"))
  expect_true(OnCran())
})

test_that("FetchUAIssue returns the issue as a list if found", {
  local_mocked_bindings(
    FetchIssueUAChildren = function(...) {
      data.frame(
        Number = 123:124,
        Title = c(
          paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
          "Wrong item"
        ),
        State = "closed",
        Url = paste0("http://example.com/issue/", 123:124)
      )
    }
  )
  result <- FetchUAIssue(
    intIssue = 123,
    chrChecks = c("check1", "check2")
  )
  expect_identical(
    result,
    list(
      Number = 123L,
      Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
      State = "closed",
      Url = "http://example.com/issue/123"
    )
  )
})

test_that("FetchUAIssue returns the issue as a list if created", {
  local_mocked_bindings(
    FetchIssueUAChildren = function(...) {
      data.frame(
        Number = integer(),
        Title = character(),
        State = character(),
        Url = character()
      )
    },
    CreateUAIssue = function(...) {
      data.frame(
        Number = 123L,
        Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
        State = "closed",
        Url = "http://example.com/issue/123"
      )
    }
  )
  result <- FetchUAIssue(
    intIssue = 123,
    chrChecks = c("check1", "check2")
  )
  expect_identical(
    result,
    list(
      Number = 123L,
      Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
      State = "closed",
      Url = "http://example.com/issue/123"
    )
  )
})

test_that("FetchIssueUAChildren fetches 'qcthat-uat'-labeled child issues", {
  local_mocked_bindings(
    FetchIssueChildren = function(...) {
      tibble::tibble(
        Number = 1:2,
        Labels = list(list(), list("qcthat-uat"))
      )
    }
  )
  expect_equal(FetchIssueUAChildren(123)$Number, 2)
})

test_that("CreateUAIssue constructs the expected call", {
  local_mocked_bindings(
    CreateChildIssue = function(...) list(...)
  )
  expect_equal(
    CreateUAIssue(
      intIssue = 123L,
      chrChecks = c("Check 1", "Check 2"),
      chrInstructions = "These are instructions",
      strOwner = "test-owner",
      strRepo = "test-repo",
      strGHToken = "test-token"
    ),
    list(
      123L,
      paste("qcthat Acceptance:", rlang::hash(c("Check 1", "Check 2"))),
      "Review the following checks and close this issue to indicate your acceptance.\n\nThese are instructions\n\n- [ ] Check 1\n- [ ] Check 2",
      chrLabels = "qcthat-uat",
      strOwner = "test-owner",
      strRepo = "test-repo",
      strGHToken = "test-token"
    )
  )
})
