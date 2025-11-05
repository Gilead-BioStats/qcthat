test_that("Printing an IssueTestMatrix returns input invisibly (#31)", {
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = tibble::tibble(),
    dfTestResults = tibble::tibble()
  )
  expect_unformatted_snapshot({
    # Adds `visible` flag to object
    test_result <- withVisible(print(dfITM))
  })
  expect_false(test_result$visible)
  expect_identical(test_result$value, dfITM)
})

test_that("Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36, #60)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_unformatted_snapshot({
    dfITM
  })
})

test_that("Disposition indicators deal with all cases (#60)", {
  expect_null(MakeITRDispositionFooter(NA_character_))
  expect_null(ChooseOverallDispositionMessage(NA_character_))
  expect_identical(
    ChooseOverallDispositionMessage("pass"),
    "All tests passed"
  )
  expect_identical(
    ChooseOverallDispositionMessage("skip"),
    "At least one test was skipped"
  )
  expect_identical(
    ChooseOverallDispositionMessage("weird status"),
    "Tests have unknown disposition"
  )
})
