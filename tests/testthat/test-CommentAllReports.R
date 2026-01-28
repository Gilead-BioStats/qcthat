test_that("FormatReportBody finalizes reports (#165)", {
  expect_equal(
    FormatReportBody(
      strReportType = "Test Report",
      strBody = "Text of the report."
    ),
    "### Test Report\nText of the report.\n<hr>"
  )
})

test_that("FormatReportType generates a report type (#165)", {
  local_mocked_bindings(
    FormatReportGH = function(dfITM) paste("Formatted report for", dfITM)
  )
  fnReportTest <- function(strOtherArg, ...) {
    paste(
      "Report generated with arg:",
      strOtherArg,
      paste(..., sep = " | "),
      sep = "\n"
    )
  }
  test_result <- FormatReportType(
    fnReport = fnReportTest,
    strReportType = "Test Report",
    strPkgRoot = "path/to/repo",
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken",
    chrIgnoredLabels = "ignored",
    dfITM = "testdf",
    lOtherArgs = list(strOtherArg = "other value"),
    envCall = "call"
  )
  expect_equal(
    test_result,
    "### Test Report\nFormatted report for Report generated with arg:\nother value\npath/to/repo | testowner | testrepo | testtoken | ignored | testdf | call\n<hr>"
  )
})

test_that("CommentAllReports generates the expected calls (#165)", {
  local_mocked_bindings(
    FormatReportType = function(fnReport, strReportType, ...) {
      paste("Formatted", strReportType)
    },
    CommentIssue = function(intIssue, strTitle, strBody, ...) {
      expect_equal(intIssue, 42)
      expect_equal(
        strTitle,
        "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Reports"
      )
      expect_equal(
        strBody,
        paste(
          "Formatted PR-Associated Issues",
          "Formatted Milestone",
          "Formatted Completed Issues",
          sep = "\n\n\n"
        )
      )
      cli::cli_inform(
        "CommentIssue called for PR #{intIssue} with title '{strTitle}' and body '{strBody}'",
        class = "test-comment-issue"
      )
    },
    CommentUAT = function(intPRNumber, ...) {
      cli::cli_inform("CommentUAT called for PR #{intPRNumber}")
    }
  )
  expect_message(
    {
      expect_message(
        {
          returned_value <- expect_invisible({
            CommentAllReports(
              intPRNumber = 42,
              dfITM = "testdf",
              chrMilestones = "testmilestone",
              strRunID = "",
              strOwner = "testowner",
              strRepo = "testrepo",
              strGHToken = "testtoken"
            )
          })
        },
        "CommentUAT called for PR #42"
      )
    },
    class = "test-comment-issue"
  )
  expect_equal(returned_value, "testdf")

  local_mocked_bindings(
    CommentIssue = function(intIssue, strTitle, strBody, ...) {
      expect_equal(intIssue, 42)
      expect_equal(
        strBody,
        paste(
          "Formatted PR-Associated Issues",
          sep = "\n\n\n"
        )
      )
    },
    CommentUAT = function(intPRNumber, ...) {
      stop("CommentUAT should not be called")
    }
  )

  expect_no_error({
    CommentAllReports(
      intPRNumber = 42,
      dfITM = "testdf",
      chrMilestones = NULL,
      lglUAT = FALSE,
      lglCompleted = FALSE,
      strRunID = "",
      strOwner = "testowner",
      strRepo = "testrepo",
      strGHToken = "testtoken"
    )
  })
})

test_that("All qcthat reports are combined in a single GHA (#129, #165, #152)", {
  ExpectUserAccepts(
    "PRs have a single comment for qcthat reports (other than UAT)",
    intIssue = 165,
    chrChecks = c(
      "The PR associated with this issue has a comment with the title '{qcthat} Reports', containing both the 'PR-Associated Issues' and 'Completed Issues' reports.",
      "The PR associated with this issue does not have a comment for just the '{qcthat} Report: Completed Issues'.",
      "The PR associated with this issue does not have a comment for just the '{qcthat} Report: PR-Associated Issues'."
    )
  )
  ExpectUserAccepts(
    "PRs have a single qcthat action",
    intIssue = 129,
    chrInstructions = "At the bottom of the PR associated with this issue, look for the 'checks' folder (or 'All checks have passed', etc), and expand that folder.",
    chrChecks = c(
      "The PR associated with this issue has a 'qcthat Quality Control' check.",
      "The PR associated with this issue does *not* have any other checks that begin with 'qcthat'."
    )
  )
})
