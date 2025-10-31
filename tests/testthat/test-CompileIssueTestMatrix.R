test_that("CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35)", {
  expect_no_error({
    test_result <- CompileIssueTestMatrix(
      dfRepoIssues = tibble::tibble(),
      dfTestResults = tibble::tibble()
    )
  })
  expect_s3_class(test_result, "qcthat_IssueTestMatrix")
  expect_s3_class(test_result, "tbl_df")
  expect_equal(nrow(test_result), 0)
  expect_setequal(
    colnames(test_result),
    c(
      "Milestone",
      "Issue",
      "Title",
      "Body",
      "Labels",
      "State",
      "StateReason",
      "Type",
      "Url",
      "ParentOwner",
      "ParentRepo",
      "ParentNumber",
      "CreatedAt",
      "ClosedAt",
      "Test",
      "File",
      "Disposition"
    )
  )
})

test_that("CompileIssueTestMatrix combines issues and test results into an IssueTestMatrix tibble (#35, #49)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  test_result <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_s3_class(test_result, "qcthat_IssueTestMatrix")
  expect_s3_class(test_result, "tbl_df")
  expect_setequal(
    colnames(test_result),
    c(
      "Milestone",
      "Issue",
      "Title",
      "Body",
      "Labels",
      "State",
      "StateReason",
      "Type",
      "Url",
      "ParentOwner",
      "ParentRepo",
      "ParentNumber",
      "CreatedAt",
      "ClosedAt",
      "Test",
      "File",
      "Disposition"
    )
  )
})
