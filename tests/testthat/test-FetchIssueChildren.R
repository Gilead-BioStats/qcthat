test_that("FetchIssueChildren returns a DF of issue children", {
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
