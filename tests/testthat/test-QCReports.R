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
    "repo issues|test results|qcthat-nocov"
  )
  expect_identical(
    QCPackage(
      strPkgRoot = "package root",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token",
      chrIgnoredLabels = character()
    ),
    "repo issues|test results|"
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

test_that("QCIssues reports on specific issues (#86)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Issue = 1:3,
        OtherColumn = 1:3
      )
    }
  )
  expected_result <- tibble::tibble(Issue = 2:3, OtherColumn = 2:3)
  expect_identical(QCIssues(2:3), expected_result)
})

test_that("QCIssues warns about unknown issues (#86)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Issue = 1:3,
        OtherColumn = 1:3
      )
    }
  )
  expect_warning(
    test_result <- QCIssues(2:4),
    "Unknown issues: 4",
    class = "qcthat-warning-unknown_issues"
  )
  expected_result <- tibble::tibble(Issue = 2:3, OtherColumn = 2:3)
  expect_identical(test_result, expected_result)
})

test_that("QCIssues errors with no valid issues (#86)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Issue = 1:3,
        OtherColumn = 1:3
      )
    }
  )
  expect_error(
    test_result <- QCIssues(4),
    "Unknown issues: 4",
    class = "qcthat-error-unknown_issues"
  )
})

test_that("QCMilestones reports on specific milestones (#88, #68)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Milestone = c("A", "B", "A"),
        Issue = 1:3,
        OtherColumn = 1:3,
        StateReason = NA
      )
    }
  )
  expected_result <- tibble::tibble(
    Milestone = "A",
    Issue = c(1L, 3L),
    OtherColumn = Issue,
    StateReason = NA
  )
  expect_identical(QCMilestones("A"), expected_result)
})

test_that("QCMilestones warns about unknown milestones (#88)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Milestone = c("A", "B", "A"),
        Issue = 1:3,
        OtherColumn = 1:3,
        StateReason = NA
      )
    }
  )
  expect_warning(
    test_result <- QCMilestones(c("A", "C")),
    "Unknown milestones: C",
    class = "qcthat-warning-unknown_milestones"
  )
  expected_result <- tibble::tibble(
    Milestone = "A",
    Issue = c(1L, 3L),
    OtherColumn = Issue,
    StateReason = NA
  )
  expect_identical(test_result, expected_result)
})

test_that("QCMilestones errors with no valid milestones (#88)", {
  local_mocked_bindings(
    QCPackage = function(...) {
      tibble::tibble(
        Milestone = c("A", "B", "A"),
        Issue = 1:3,
        OtherColumn = 1:3,
        StateReason = NA
      )
    }
  )
  expect_error(
    QCMilestones("C"),
    "Unknown milestones: C",
    class = "qcthat-error-unknown_milestones"
  )
})
