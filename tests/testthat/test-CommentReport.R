test_that("CommentReport generates the expected call (#99, #72, #295)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...),
    LinkSessionInfo = function(...) "SESSINO INFO LINK"
  )
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strRunID = "",
      strJobName = "",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})
