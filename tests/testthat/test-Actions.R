test_that("Action_qcthat calls InstallAction with the expected arguments (#205, #303)", {
  local_mocked_bindings(
    InstallAction = function(strActionName, ...) {
      list(strActionName = strActionName, ...)
    }
  )
  expect_equal(
    Action_qcthat(lglOverwrite = TRUE, strPkgRoot = "test-pkg"),
    list(
      strActionName = "qcthat",
      strPkgRoot = "test-pkg",
      lglOverwrite = TRUE
    )
  )
})

test_that("Action_qcthat fails if a YAML file already exists and lglOverwrite is FALSE (#205, #303)", {
  local_mocked_bindings(
    FileExists = function(strPath) {
      TRUE
    }
  )
  expect_error(
    Action_qcthat(lglOverwrite = FALSE, strPkgRoot = "test-pkg"),
    class = "qcthat-error-action_exists"
  )
})

test_that("InstallAction returns the installation path invisibly (#205, #303)", {
  local_mocked_bindings(
    FileExists = function(strPath) {
      FALSE
    },
    UseActionInProject = function(...) {
      # Do nothing
    }
  )
  expect_equal(
    InstallAction("test-action", lglOverwrite = TRUE, strPkgRoot = "test-pkg"),
    invisible(fs::path("test-pkg", ".github", "workflows", "test-action.yaml"))
  )
})

test_that("Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)", {
  local_mocked_bindings(
    InstallAction = function(strActionName, ...) {
      strActionName
    }
  )
  expect_identical(Action_qcthat(), "qcthat")
})

test_that("Reports generated via GHA include information about the issues (#77, #37)", {
  qcthat::ExpectUserAccepts(
    "qcthat reports show the expected issue information",
    intIssue = 77,
    chrInstructions = "Check the reports in the PR mentioned at the end of this issue (scroll to the bottom of this page, look for 'github-actions mentioned this').",
    chrChecks = c(
      "Newly generated qcthat reports show the type, title, status, and milestone (if any) of issues."
    )
  )
})

test_that("Additional user acceptance sub-issue is generated in the qcthat User Acceptance report (#83)", {
  qcthat::ExpectUserAccepts(
    "qcthat reports show the expected test and issue information",
    intIssue = 83,
    chrInstructions = "Check {qcthat} Report: User Acceptance ",
    chrChecks = c(
      "Generated qcthat reports shows additional sub-issue for user acceptance test #83."
    )
  )
})
