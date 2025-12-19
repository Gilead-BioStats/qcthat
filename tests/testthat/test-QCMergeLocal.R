test_that("QCMergeLocal filters to ref-specific issues (#68, #84)", {
  local_mocked_bindings(
    FindKeywordIssues = function(...) {
      3:4
    },
    QCPackage = function(...) {
      tibble::tibble(
        Issue = c(NA, 1:5),
        OtherColumn = 1:6
      )
    }
  )
  expected_result <- tibble::tibble(Issue = 3:4, OtherColumn = 4:5)
  expect_identical(QCMergeLocal(), expected_result)
})

test_that("FindKeywordIssues extracts issues that will be closed by commits (#84)", {
  local_mocked_bindings(
    GetGitLog = function(strGitRef, ...) {
      dfBase <- tibble::tibble(
        commit = c(paste0("c", 1:3)),
        message = c("Fixes #10", "Some other change", "Minor update")
      )
      if (strGitRef == "default_branch") {
        return(dfBase)
      }
      dplyr::bind_rows(
        dfBase,
        tibble::tibble(
          commit = c(paste0("c", 4:5)),
          message = c("Closes #20 blah blah fixes #30", "This resolves #40")
        )
      )
    },
    GetPkgRoot = function(...) "."
  )
  expect_equal(
    FindKeywordIssues(
      "new_branch",
      "default_branch",
      strOwner = "owner",
      strRepo = "repo"
    ),
    c(20L, 30L, 40L)
  )
})
