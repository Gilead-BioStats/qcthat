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
