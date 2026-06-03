test_that("AssignIssueImpl errors for >1 row (#193)", {
  AssignIssueImpl(data.frame(a = 1:2)) |>
    expect_error(class = "qcthat-error-multiple_issue_assignment")
})

test_that("AssignIssueImpl calls UpdateIssue with expected values (#193)", {
  local_mocked_bindings(
    UpdateIssue = function(
      intIssue,
      ...,
      strTitle = NULL,
      strBody = NULL,
      strState = NULL,
      strStateReason = NULL,
      strMilestone = NULL,
      chrLabels = NULL,
      chrAssignees = NULL,
      strType = NULL,
      strOwner = GetGHOwner(),
      strRepo = GetGHRepo(),
      strGHToken = gh::gh_token()
    ) {
      expect_equal(intIssue, 123)
      expect_equal(chrAssignees, c("assignee1", "assignee2"))
      cli::cli_inform("Called UpdateIssue")
      return(NULL)
    }
  )
  AssignIssueImpl(
    tibble::tibble(
      Issue = 123,
      Assignees = list("assignee1")
    ),
    chrAssignees = "assignee2",
    lglOpenOnAssign = TRUE,
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  ) |>
    expect_message("Called UpdateIssue")
})

test_that("AssignIssue calls AssignIssueImpl for non-empty dfs (#193)", {
  local_mocked_bindings(
    AssignIssueImpl = function(dfIssue, ...) {
      expect_equal(nrow(dfIssue), 1)
      cli::cli_inform("Called AssignIssueImpl")
      return(NULL)
    }
  )
  AssignIssue(tibble::tibble(Issue = 123)) |>
    expect_message("Called AssignIssueImpl")
})

test_that("AssignIssue returns empty dfs unchanged (#193)", {
  expect_identical(
    AssignIssue(EmptyIssuesDF()),
    EmptyIssuesDF()
  )
})

test_that("AssignIssue looks up info about numeric issues and then assigns them (#193)", {
  local_mocked_bindings(
    FetchIssueDetails = function(
      intIssue,
      strOwner = GetGHOwner(),
      strRepo = GetGHRepo(),
      strGHToken = gh::gh_token()
    ) {
      expect_equal(intIssue, 123)
      cli::cli_inform("Called FetchIssueDetails")
      return(tibble::tibble(Issue = 123))
    },
    AssignIssueImpl = function(dfIssue, ...) {
      expect_equal(nrow(dfIssue), 1)
      expect_equal(dfIssue$Issue, 123)
      cli::cli_inform("Called AssignIssueImpl")
      return(NULL)
    }
  )
  AssignIssue(
    123,
    chrAssignees = "assignee",
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  ) |>
    expect_message("Called FetchIssueDetails") |>
    expect_message("Called AssignIssueImpl")
})
