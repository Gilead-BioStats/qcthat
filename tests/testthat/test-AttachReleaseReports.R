test_that("UpdateReleaseBody makes the expected call (#152)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  test_result <- UpdateReleaseBody(
    strReleaseID = "releaseID",
    strBody = "New body content",
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expect_named(
    test_result,
    c("", "release_id", "body", "strOwner", "strRepo", "strGHToken")
  )
  expect_equal(
    test_result[[1]],
    "PATCH /repos/{owner}/{repo}/releases/{release_id}"
  )
})

test_that("AttachReleaseReports makes the expected calls (#152)", {
  local_mocked_bindings(
    FormatReportType = function(fnReport, strReportType, ...) {
      paste("Formatted", strReportType)
    },
    UpdateReleaseBody = function(strReleaseID, strBody, ...) {
      expect_equal(strReleaseID, "releaseID")
      expect_equal(
        strBody,
        paste(
          "Formatted Milestone",
          "Formatted Completed Issues",
          sep = "\n\n\n"
        )
      )
      cli::cli_inform("UpdateReleaseBody called")
    }
  )
  expect_message(
    {
      returned_value <- expect_invisible(
        AttachReleaseReports(
          strReleaseID = "releaseID",
          lglMilestone = TRUE,
          chrMilestones = "testmilestone",
          lglCompleted = TRUE,
          dfITM = "testdf",
          strOwner = "owner",
          strRepo = "repo",
          strGHToken = "token"
        )
      )
    },
    "UpdateReleaseBody called"
  )
  expect_equal(returned_value, "testdf")

  local_mocked_bindings(
    UpdateReleaseBody = function(strReleaseID, strBody, ...) {
      expect_equal(strReleaseID, "releaseID")
      expect_equal(
        strBody,
        "Formatted Completed Issues"
      )
      cli::cli_inform("UpdateReleaseBody called")
    }
  )
  expect_message(
    {
      returned_value <- expect_invisible(
        AttachReleaseReports(
          strReleaseID = "releaseID",
          lglMilestone = FALSE,
          chrMilestones = character(),
          lglCompleted = TRUE,
          dfITM = "testdf",
          strOwner = "owner",
          strRepo = "repo",
          strGHToken = "token"
        )
      )
    },
    "UpdateReleaseBody called"
  )
  expect_equal(returned_value, "testdf")
})
