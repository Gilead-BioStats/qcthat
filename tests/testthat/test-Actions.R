test_that("InstallAction calls InstallFile with expected parts (#73)", {
  local_mocked_bindings(
    InstallFile = function(...) {
      list(...)
    }
  )
  test_result <- InstallAction(strActionName = "testAction")
  expect_type(test_result$envCall, "environment")
  test_result$envCall <- NULL
  expect_identical(
    test_result,
    list(
      chrSourcePath = c("workflows", "qcthat-testAction"),
      chrTargetPath = c(".github", "workflows", "qcthat-testAction"),
      strExtension = "yaml",
      lglOverwrite = FALSE,
      strPkgRoot = "."
    )
  )
})

test_that("Action_QCCompletedIssues targets the expected action (#73, #69)", {
  local_mocked_bindings(
    InstallAction = function(strActionName, ...) {
      strActionName
    }
  )
  expect_identical(Action_QCCompletedIssues(), "completed_issues")
})

test_that("Action_QCPRIssues targets the expected action (#55, #68)", {
  local_mocked_bindings(
    InstallAction = function(strActionName, ...) {
      strActionName
    }
  )
  expect_identical(Action_QCPRIssues(), "pr_issues")
})

test_that("Action_QCMilestone targets the expected action (#88, #68)", {
  local_mocked_bindings(
    InstallAction = function(strActionName, ...) {
      strActionName
    }
  )
  expect_identical(Action_QCMilestone(), "milestone")
})

test_that("qcthat is installed as part of the GHA (#95)", {
  ExpectUserAccepts(
    "The qcthat GHAs install qcthat",
    intIssue = 95,
    chrInstructions = "Call the functions in a repo other than qcthat, with qcthat installed locally. Ensure that the installed workflows install qcthat.",
    chrChecks = c(
      "The action added to a repository via Action_QCCompletedIssues() installs qcthat.",
      "The action added to a repository via Action_QCPRIssues() installs qcthat.",
      "The action added to a repository via Action_QCMilestone() installs qcthat."
    )
  )
})

test_that("Reports generated via GHA include information about the issues (#77)", {
  ExpectUserAccepts(
    "qcthat reports show the expected issue information",
    intIssue = 77,
    chrInstructions = "Check the reports in any PRs attached to issue #77.",
    chrChecks = c(
      "Newly generated qcthat reports show the type, title, status, and milestone (if any) of issues."
    )
  )
})
