test_that("Printing an IssueTestMatrix returns input invisibly (#36)", {
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = tibble::tibble(),
    dfTestResults = tibble::tibble()
  )
  expect_unformatted_snapshot(
    # Adds `visible` flag to object
    test_result <- withVisible(print(dfITM))
  )
  expect_false(test_result$visible)
  expect_identical(test_result$value, dfITM)
})

test_that("Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_unformatted_snapshot(
    dfITM
  )
})

test_that("Formatting an IssueTestMatrix can return the formatted tree directly", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_unformatted_snapshot(
    format(dfITM)
  )
})
