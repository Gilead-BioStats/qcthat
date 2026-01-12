test_that("CommentReport generates the expected call (#99)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...)
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
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})
