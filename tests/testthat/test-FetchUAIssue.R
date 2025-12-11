test_that("FetchUAIssue returns the issue as a list if found (#111)", {
  local_mocked_bindings(
    FetchIssueUAChildren = function(...) {
      data.frame(
        Number = 123:124,
        Title = c(
          paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
          "Wrong item"
        ),
        State = "closed",
        Url = paste0("http://example.com/issue/", 123:124)
      )
    }
  )
  result <- FetchUAIssue(
    intIssue = 123,
    chrChecks = c("check1", "check2")
  )
  expect_identical(
    result,
    list(
      Number = 123L,
      Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
      State = "closed",
      Url = "http://example.com/issue/123"
    )
  )
})

test_that("FetchUAIssue returns the issue as a list if created (#111)", {
  local_mocked_bindings(
    FetchIssueUAChildren = function(...) {
      data.frame(
        Number = integer(),
        Title = character(),
        State = character(),
        Url = character()
      )
    },
    CreateUAIssue = function(...) {
      data.frame(
        Number = 123L,
        Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
        State = "closed",
        Url = "http://example.com/issue/123"
      )
    }
  )
  result <- FetchUAIssue(
    intIssue = 123,
    chrChecks = c("check1", "check2")
  )
  expect_identical(
    result,
    list(
      Number = 123L,
      Title = paste("qcthat Acceptance:", rlang::hash(c("check1", "check2"))),
      State = "closed",
      Url = "http://example.com/issue/123"
    )
  )
})

test_that("FetchIssueUAChildren fetches 'qcthat-uat'-labeled child issues (#111)", {
  local_mocked_bindings(
    FetchIssueChildren = function(...) {
      tibble::tibble(
        Number = 1:2,
        Labels = list(list(), list("qcthat-uat"))
      )
    }
  )
  expect_equal(FetchIssueUAChildren(123)$Number, 2)
})

test_that("FetchIssueChildren returns a DF of issue children (#111)", {
  local_mocked_bindings(
    CallGHAPI = function(
      strEndpoint,
      strOwner,
      strRepo,
      strGHToken,
      issue_number,
      ...
    ) {
      strParentUrl <- glue::glue(
        "https://api.github.com/repos/{strOwner}/{strRepo}/issues/{issue_number}"
      )
      list(
        list(
          number = 101,
          title = "Child issue 1",
          state = "open",
          parent_issue_url = strParentUrl
        ),
        list(
          number = 102,
          title = "Child issue 2",
          state = "closed",
          parent_issue_url = strParentUrl
        )
      )
    }
  )
  result <- FetchIssueChildren(123, "testowner", "testrepo", "testtoken")
  expect_s3_class(result, "qcthat_Issues")
  expect_mapequal(
    unclass(result),
    list(
      Issue = 101:102,
      Title = c("Child issue 1", "Child issue 2"),
      State = c("open", "closed"),
      ParentOwner = c("testowner", "testowner"),
      ParentRepo = c("testrepo", "testrepo"),
      ParentNumber = c(123, 123),
      Body = c(NA_character_, NA_character_),
      Labels = list(NULL, NULL),
      StateReason = c(NA_character_, NA_character_),
      Milestone = c(NA_character_, NA_character_),
      Type = c("Issue", "Issue"),
      Url = c(NA_character_, NA_character_),
      CreatedAt = as.POSIXct(c(NA, NA), tz = "UTC"),
      ClosedAt = as.POSIXct(c(NA, NA), tz = "UTC")
    )
  )
})
