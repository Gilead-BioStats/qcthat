test_that("SaveAsJSON and ReadJSONAsIssueTestMatrix save and read dfITM to/from JSON (#298)", {
  strPath <- withr::local_tempfile(fileext = ".json")
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  SaveAsJSON(dfITM, strPath)
  dfITM2 <- ReadJSONAsIssueTestMatrix(strPath)
  expect_identical(dfITM2, dfITM)
})

test_that("SaveAsJSON saves non-ITM objects to JSON (#298)", {
  strPath <- withr::local_tempfile(fileext = ".json")
  lst <- list(a = 1L, b = "text", c = TRUE)
  SaveAsJSON(lst, strPath)
  lst2 <- jsonlite::fromJSON(strPath)
  expect_identical(lst2, lst)
})
