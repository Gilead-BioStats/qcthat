test_that("Printing a Milestone returns input invisibly (#39)", {
  lMilestone <- AsMilestone(NULL)
  # Adds `visible` flag to object
  test_result <- withVisible(print(lMilestone))
  expect_false(test_result$visible)
  expect_identical(test_result$value, lMilestone)
})

test_that("Printing a Milestone outputs a user-friendly tree (#39)", {
  dfITMNested <- AsNestedIssueTestMatrix(CompileIssueTestMatrix(
    GenerateSampleDFRepoIssues(),
    GenerateSampleDFTestResults()
  ))
  lMilestones <- AsRowDFList(dfITMNested, AsMilestone)
  expect_unformatted_snapshot({
    lMilestones[[1]]
  })
  expect_unformatted_snapshot({
    lMilestones[[2]]
  })
})
