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

test_that("CompileIssueTestMatrix excludes issues in chrIgnoredLabels (#67)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  test_result_with_nocov <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  test_result_no_nocov <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults,
    chrIgnoredLabels = DefaultIgnoreLabels()
  )
  expect_lt(
    nrow(test_result_no_nocov),
    nrow(test_result_with_nocov)
  )
  # Our labels for the test are only length-1, so we can subset relatively
  # easily.
  nocov_issues <- c(
    dfRepoIssues$Issue[dfRepoIssues$Labels == "qcthat-nocov"],
    dfRepoIssues$Issue[dfRepoIssues$Labels == "qcthat-uat"]
  )
  # This can be cleaner as of testthat 3.3.0, but some of our machines use
  # 3.2.3.
  #
  # expect_disjoint(test_result_no_nocov$Issue, nocov_issues)
  expect_false(any(test_result_no_nocov$Issue %in% nocov_issues))
  expect_contains(test_result_with_nocov$Issue, nocov_issues)

  lIgnoredIssues <- attr(test_result_no_nocov, "IgnoredIssues")
  expect_type(lIgnoredIssues, "list")
  expect_named(lIgnoredIssues, DefaultIgnoreLabels())
  expect_identical(
    dplyr::bind_rows(lIgnoredIssues)$Issue,
    nocov_issues
  )
})

test_that("filter also removes ignored issues (#118)", {
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  full_ITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults,
    chrIgnoredLabels = DefaultIgnoreLabels()
  )
  expect_gte(NROW(dplyr::bind_rows(attr(full_ITM, "IgnoredIssues"))), 1)

  filtered_ITM <- dplyr::filter(full_ITM, Issue == 35)
  expect_equal(NROW(dplyr::bind_rows(attr(filtered_ITM, "IgnoredIssues"))), 0)
})
