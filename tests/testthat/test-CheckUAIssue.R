test_that("CheckUAIssue passes when the issue is closed (#65, #111)", {
  local_mocked_bindings(
    FetchUAIssue = function(...) {
      list(State = "closed", Url = "http://example.com/issue/123")
    }
  )
  local_dfUATIssues()
  expect_success({
    CheckUAIssue(
      strDescription = "The thing renders",
      intIssue = 12L,
      chrChecks = c("check1", "check2"),
      chrAssignees = "",
      strOwner = "owner",
      strRepo = "repo"
    )
  })
})

test_that("CheckUAIssue fails when the issue is open (#65, #111)", {
  local_mocked_bindings(
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    }
  )
  local_dfUATIssues()
  expect_failure(
    {
      CheckUAIssue(
        strDescription = "The thing renders",
        intIssue = 12L,
        chrChecks = c("check1", "check2"),
        lglReportFailure = TRUE,
        chrAssignees = "",
        strOwner = "owner",
        strRepo = "repo"
      )
    },
    "http://example.com/issue/123"
  )
})

test_that("CheckUAIssue fails when the child issue can't be created (#137)", {
  local_mocked_bindings(
    FetchUAIssue = function(...) {
      list(State = "failed_to_create")
    }
  )
  local_dfUATIssues()
  expect_failure(
    {
      CheckUAIssue(
        strDescription = "The thing renders",
        intIssue = 12L,
        chrChecks = c("check1", "check2"),
        lglReportFailure = TRUE,
        chrAssignees = "",
        strOwner = "owner",
        strRepo = "repo"
      )
    },
    "Failed to create"
  )
})

test_that("CheckUAIssue fails when weird things happen (#137)", {
  local_mocked_bindings(
    FetchUAIssue = function(...) NULL
  )
  local_dfUATIssues()
  expect_failure(
    {
      CheckUAIssue(
        strDescription = "The thing renders",
        intIssue = 12L,
        chrChecks = c("check1", "check2"),
        lglReportFailure = TRUE,
        chrAssignees = "",
        strOwner = "owner",
        strRepo = "repo"
      )
    },
    "Unexpected state"
  )
})

test_that("CheckUAIssue returns silently when the issue isn't closed and lglReportFailure is FALSE (#111)", {
  local_mocked_bindings(
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    }
  )
  local_dfUATIssues()
  chrChecks <- c("check1", "check2")
  strDescription <- "The thing renders"
  result <- CheckUAIssue(
    strDescription = strDescription,
    intIssue = 12L,
    chrChecks = chrChecks,
    chrAssignees = "",
    strOwner = "owner",
    strRepo = "repo",
    lglReportFailure = FALSE
  )
  expect_identical(result$Description, strDescription)
  expect_identical(result$Disposition, "pending")
})

test_that("LogUAT logs UAT status (#115)", {
  local_dfUATIssues()

  strRandom1 <- paste(sample(letters, 32, replace = TRUE), collapse = "")
  strRandom2 <- paste(sample(letters, 32, replace = TRUE), collapse = "")
  dttmTSBase <- as.POSIXct("2025-12-19 08:28:00", tz = "UTC")

  LogUAT(
    intParentIssue = 10L,
    intUATIssue = 20L,
    strDescription = strRandom1,
    strDisposition = "pending",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10L,
      UATIssue = 20L,
      Description = strRandom1,
      Disposition = "pending",
      Owner = "owner",
      Repo = "repo",
      Timestamp = dttmTSBase
    )
  )
  LogUAT(
    intParentIssue = 11L,
    intUATIssue = 21L,
    strDescription = strRandom2,
    strDisposition = "pending",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase + 1
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10:11,
      UATIssue = 20:21,
      Description = c(strRandom1, strRandom2),
      Disposition = c("pending", "pending"),
      Owner = "owner",
      Repo = "repo",
      Timestamp = c(dttmTSBase, dttmTSBase + 1)
    )
  )
  LogUAT(
    intParentIssue = 10L,
    intUATIssue = 20L,
    strDescription = strRandom1,
    strDisposition = "accepted",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase + 2
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10:11,
      UATIssue = 20:21,
      Description = c(strRandom1, strRandom2),
      Disposition = c("accepted", "pending"),
      Owner = "owner",
      Repo = "repo",
      Timestamp = c(dttmTSBase + 2, dttmTSBase + 1)
    ) |>
      dplyr::arrange(.data$Timestamp)
  )
})

test_that("CheckUAIssue errors when online but GitHub fetch fails (#230)", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    CallGHAPI = function(...) NULL,
    IsOnline = function() TRUE
  )
  local_dfUATIssues()
  expect_error(
    CheckUAIssue(
      strDescription = "The thing renders",
      intIssue = 12L,
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "Failed to fetch issues from GitHub",
    class = "qcthat-error-bad_gh_response"
  )
})

test_that("CheckUAIssue assigns issues when assignees are available", {
  local_mocked_bindings(
    FetchUAIssue = function(...) {
      list(Issue = 123L, State = "closed", Url = "http://example.com/issue/123")
    },
    AssignIssue = function(lUAIssue, chrAssignees, ...) {
      lUAIssue$Assignees <- chrAssignees
      lUAIssue$State = "open"
      return(lUAIssue)
    }
  )
  local_dfUATIssues()
  # Success without a (new) assignee.
  CheckUAIssue(
    strDescription = "The thing renders",
    intIssue = 123L,
    chrChecks = c("check1", "check2"),
    chrAssignees = "",
    lglReportFailure = TRUE,
    strOwner = "owner",
    strRepo = "repo"
  ) |>
    expect_success()
  # Open (thus failure) with new assignee.
  CheckUAIssue(
    strDescription = "The thing renders",
    intIssue = 123L,
    chrChecks = c("check1", "check2"),
    chrAssignees = "new_assignee",
    lglReportFailure = TRUE,
    strOwner = "owner",
    strRepo = "repo"
  ) |>
    expect_failure("http://example.com/issue/123")
})
