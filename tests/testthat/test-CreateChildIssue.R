test_that("CreateChildIssue uses the expected process", {
  local_mocked_bindings(
    CreateRepoIssueRaw = function(strTitle, strBody, chrLabels, ...) {
      list(
        number = 42L,
        id = "testid",
        title = strTitle,
        body = strBody,
        labels = list(list(name = chrLabels))
      )
    },
    ConnectChildIssueByID = function(
      strChildIssueID,
      intParentIssue,
      strOwner,
      strRepo,
      ...
    ) {
      glue::glue(
        "https://api.github.com/repos/{strOwner}/{strRepo}/issues/{intParentIssue}"
      )
    }
  )
  result <- CreateChildIssue(
    intParentIssue = 1L,
    strTitle = "Test Child Issue",
    strBody = "This is a test child issue.",
    chrLabels = "test-label",
    strOwner = "test-owner",
    strRepo = "test-repo"
  )
  expect_s3_class(result, "qcthat_Issues")
  expect_equal(result$Issue, 42L)
  expect_equal(result$ParentNumber, 1L)
})

test_that("CreateRepoIssueRaw hits the expected endpoint (#65)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  expect_equal(
    CreateRepoIssueRaw(
      strTitle = "Test Issue",
      strBody = "This is a test issue body.",
      chrLabels = c("label1", "label2"),
      strOwner = "test-owner",
      strRepo = "test-repo",
      strGHToken = "test-token"
    ),
    list(
      "POST /repos/{owner}/{repo}/issues",
      title = "Test Issue",
      body = "This is a test issue body.",
      labels = list("label1", "label2"),
      numLimit = NULL,
      strOwner = "test-owner",
      strRepo = "test-repo",
      strGHToken = "test-token"
    )
  )
})

test_that("ConnectChildIssueByID returns the URL to the parent", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  expect_equal(
    ConnectChildIssueByID(
      strChildIssueID = "child-issue-id",
      intParentIssue = 123L,
      strOwner = "test-owner",
      strRepo = "test-repo"
    ),
    "https://api.github.com/repos/test-owner/test-repo/issues/123"
  )
})
