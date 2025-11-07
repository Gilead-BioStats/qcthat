test_that("QCPackage wraps the core qcthat functions (#46, #69)", {
  local_mocked_bindings(
    FetchRepoIssues = function(...) "repo issues",
    GetPkgRoot = function(strPkgRoot, ...) strPkgRoot,
    CompileTestResults = function(...) "test results",
    CompileIssueTestMatrix = function(...) paste(..., sep = "|")
  )
  expect_identical(
    QCPackage(
      strPkgRoot = "package root",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "repo issues|test results"
  )
})

test_that("QCCompletedIssues filters to completed issues (#80, #69)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        StateReason = c(NA, "completed", "other", "completed"),
        OtherColumn = 1:4
      )
    }
  )
  test_result <- QCCompletedIssues(
    strPkgRoot = "package root",
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expected_result <- tibble::tibble(
    StateReason = c("completed", "completed"),
    OtherColumn = c(2L, 4L)
  )
  expect_identical(test_result, expected_result)
})
