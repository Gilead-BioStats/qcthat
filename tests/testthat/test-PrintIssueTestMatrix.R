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

test_that("Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36, #60, #85)", {
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
  expect_null(
    MakeITRDispositionFooter(
      tibble::tibble(
        Test = "Test",
        File = "test-test.R",
        Disposition = NA_character_
      )
    )
  )
  expect_null(ChooseOverallDispositionMessage(NA_character_))
  expect_identical(
    ChooseOverallDispositionMessage("pass"),
    "All tests passed"
  )
  expect_identical(
    ChooseOverallDispositionMessage("skip"),
    "1 test was skipped"
  )
  expect_identical(
    ChooseOverallDispositionMessage("warn"),
    "1 test generated warnings"
  )
  expect_identical(
    ChooseOverallDispositionMessage("weird status"),
    "Tests have unknown disposition"
  )
})

test_that("Can print without milestone info (#40, #69)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_unformatted_snapshot({
    print(dfITM, lglShowMilestones = FALSE)
  })
})

test_that("MakeITRCoverageFooter deals with all cases (#85)", {
  expect_null(MakeITRCoverageFooter(integer(), character()))
  expect_equal(
    MakeITRCoverageFooter(1L, "Test", lglUseEmoji = FALSE),
    "[#] All issues have at least one test"
  )
  expect_equal(
    MakeITRCoverageFooter(NA_integer_, "Test", lglUseEmoji = FALSE),
    "[~] 1 test is not linked to any issue"
  )
  expect_equal(
    MakeITRCoverageFooter(
      c(NA_integer_, NA_integer_),
      c("Test", "Test"),
      lglUseEmoji = FALSE
    ),
    "[~] 2 tests are not linked to any issue"
  )
})

test_that("Can report ignored issue counts (#67, #81)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults,
    chrIgnoredLabels = DefaultIgnoreLabels()
  )
  expect_unformatted_snapshot({
    print(dfITM, lglShowIgnoredLabels = TRUE)
  })
})

test_that("Ignored issues are shown by default (#101)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults,
    chrIgnoredLabels = DefaultIgnoreLabels()
  )
  expect_unformatted_snapshot({
    print(dfITM)
  })
  expect_unformatted_snapshot({
    print(dfITM, lglShowIgnoredLabels = FALSE)
  })
})

test_that("Test failure counts make sense (#180, #31)", {
  qcthat::ExpectUserAccepts(
    "Test failures only count once per test",
    180,
    chrInstructions = "Load the qcthat report in the PR associated with this issue",
    chrChecks = "While this issue is open, the report says that 1 test has failed, not 2."
  )
})
