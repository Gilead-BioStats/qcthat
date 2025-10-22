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
  expect_setequal(colnames(test_result), c("Milestone", "IssueTestResults"))
})

test_that("CompileIssueTestMatrix combines issues and test results into an IssueTestMatrix tibble (#35)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  test_result <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_s3_class(test_result, "qcthat_IssueTestMatrix")
  expect_s3_class(test_result, "tbl_df")
  expect_setequal(colnames(test_result), c("Milestone", "IssueTestResults"))
})

test_that("CompileIssueTestMatrix nests by milestone (#35)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  intNMilestones <- length(unique(na.omit(dfRepoIssues$Milestone)))
  intNIssuesWithoutMilestones <- sum(is.na(dfRepoIssues$Milestone))
  intNTestsWithoutIssues <- sum(!lengths(dfTestResults$Issues))
  lglHasNAMilestone <- intNIssuesWithoutMilestones + intNTestsWithoutIssues > 0
  chrExpectedMilestones <- union(
    unique(dfRepoIssues$Milestone),
    rep(NA_character_, lglHasNAMilestone) # 0 copies if no missing milestones
  )

  test_result <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_equal(
    nrow(test_result),
    intNMilestones + as.integer(lglHasNAMilestone)
  )
  expect_setequal(
    test_result$Milestone,
    chrExpectedMilestones
  )
})

test_that("CompileIssueTestMatrix nests by issue (#35)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  test_result <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  test_subtbl <- test_result$IssueTestResults[[1]]
  intExpectedIssues <- dfRepoIssues$Issue[
    !is.na(dfRepoIssues$Milestone) &
      dfRepoIssues$Milestone == test_result$Milestone[[1]]
  ]
  expect_setequal(test_subtbl$Issue, intExpectedIssues)
  expect_contains(colnames(test_subtbl), "TestResults")
  expect_type(test_subtbl$TestResults, "list")
  expect_s3_class(test_subtbl$TestResults[[1]], "tbl_df")

  # Specifically check the NA Milestone for issue-less tests.
  test_subtbl <- test_result$IssueTestResults[is.na(test_result$Milestone)][[1]]
  intExpectedIssues <- dfRepoIssues$Issue[is.na(dfRepoIssues$Milestone)]
  has_IssuelessTests <- any(!lengths(dfTestResults$Issues))
  if (has_IssuelessTests) {
    intExpectedIssues <- c(intExpectedIssues, NA_integer_)
  }
  expect_setequal(test_subtbl$Issue, intExpectedIssues)
  expect_contains(colnames(test_subtbl), "TestResults")
  expect_type(test_subtbl$TestResults, "list")
  expect_s3_class(test_subtbl$TestResults[[3]], "tbl_df")
})
