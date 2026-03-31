test_that("UpdateIssueRaw makes the expected API call (#193)", {
  local_mocked_bindings(
    CallGHAPI = function(
      strEndpoint,
      strOwner = GetGHOwner(),
      strRepo = GetGHRepo(),
      strGHToken = gh::gh_token(),
      numLimit = Inf,
      ...
    ) {
      expect_equal(
        strEndpoint,
        "PATCH /repos/{owner}/{repo}/issues/{issue_number}"
      )
      return(list(...))
    },
    ClearGHCache = function() {
      cli::cli_inform("Called ClearGHCache()")
    }
  )
  expect_message(
    {
      test_result <- UpdateIssueRaw(
        intIssue = 123,
        strTitle = "New title",
        strBody = "New body",
        chrLabels = NULL,
        chrAssignees = character(),
        strOwner = "testowner",
        strRepo = "testrepo",
        strGHToken = "testtoken"
      )
    },
    "Called ClearGHCache()"
  )
  expect_mapequal(
    test_result,
    list(
      issue_number = 123,
      title = "New title",
      body = "New body",
      assignees = list()
    )
  )
})

test_that("UpdateIssue makes the expected calls (#193)", {
  local_mocked_bindings(
    UpdateIssueRaw = function(
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
      expect_equal(strTitle, "New title")
      list(list(
        number = intIssue,
        title = strTitle,
        state = "open"
      ))
    }
  )
  test_result <- UpdateIssue(
    intIssue = 123,
    strTitle = "New title",
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_equal(test_result$Issue, 123)
  expect_equal(test_result$Title, "New title")
})
