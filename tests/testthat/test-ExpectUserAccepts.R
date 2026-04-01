test_that("ExpectUserAccepts returns the input strDescription (#111)", {
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

test_that("ExpectUserAccepts checks the issue when requirements are met (#111)", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    IsOnline = function() TRUE,
    CheckUAIssue = function(strDescription, chrChecks, ...) {
      expect_identical(strDescription, "The thing renders")
      expect_identical(chrChecks, c("check1", "check2"))
      return(NULL)
    }
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

test_that("IsCheckingUAT reports whether the qcthat_UAT envvar is true (#111)", {
  withr::local_envvar(list(qcthat_UAT = "true"))
  expect_true(IsCheckingUAT())
  withr::local_envvar(list(qcthat_UAT = "false"))
  expect_false(IsCheckingUAT())
  withr::local_envvar(list(qcthat_UAT = ""))
  expect_false(IsCheckingUAT())
})
