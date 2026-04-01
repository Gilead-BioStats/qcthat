test_that("InstallAction calls InstallFile with expected parts (#73)", {
  local_mocked_bindings(
    InstallFile = function(
      chrSourcePath,
      chrTargetPath,
      strExtension,
      lglOverwrite,
      strPkgRoot,
      envCall
    ) {
      expect_identical(
        chrSourcePath,
        c("workflows", "qcthat-testAction")
      )
      expect_identical(
        chrTargetPath,
        c(".github", "workflows", "qcthat-testAction")
      )
      expect_identical(strExtension, "yaml")
      expect_identical(lglOverwrite, FALSE)
      expect_identical(strPkgRoot, ".")
      expect_type(envCall, "environment")
      "mocked_path"
    }
  )
  expect_identical(
    InstallAction(strActionName = "testAction"),
    "mocked_path"
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
