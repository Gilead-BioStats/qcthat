test_that("Printing a SingleIssueTestResults returns input invisibly", {
  lSingleIssueTestResults <- AsSingleIssueTestResults(NULL)
  # Adds `visible` flag to object
  test_result <- withVisible(print(lSingleIssueTestResults))
  expect_false(test_result$visible)
  expect_identical(test_result$value, lSingleIssueTestResults)
})

test_that("Printing a SingleIssueTestResults outputs a user-friendly tree", {
  dfITMNested <- AsNestedIssueTestMatrix(CompileIssueTestMatrix(
    GenerateSampleDFRepoIssues(),
    GenerateSampleDFTestResults()
  ))
  lMilestones <- AsRowDFList(dfITMNested, AsMilestone)
  lSeparatedIssueTestResults <- AsRowDFList(
    lMilestones[[1]]$IssueTestResults,
    AsSingleIssueTestResults
  )
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[1]]
  })
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[2]]
  })
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[3]]
  })
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[4]]
  })
  lSeparatedIssueTestResults <- AsRowDFList(
    lMilestones[[2]]$IssueTestResults,
    AsSingleIssueTestResults
  )
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[1]]
  })
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[2]]
  })
  expect_unformatted_snapshot({
    lSeparatedIssueTestResults[[3]]
  })
})

test_that("Issues closed as duplicates display the proper symbol (#61)", {
  expect_identical(
    ChooseStateIndicator("duplicate", lglUseEmoji = FALSE),
    "[-]"
  )
})
