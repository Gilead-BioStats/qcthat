test_that("CommentIssue compiles the body as expected (#83)", {
  local_mocked_bindings(
    CommentIssueRaw = function(strBodyCompiled, ...) strBodyCompiled
  )
  test_result <- CommentIssue(
    intIssue = 1,
    strTitle = "Test Title",
    strBody = "This is a test comment.",
    lglUpdate = FALSE,
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    "## Test Title\n\nThis is a test comment.\n\n<!-- qcthat-comment-id: 0b0a574c2bcc14f97e3ee223d93f0032 -->"
  )
})

test_that("CommentIssue updates when told to do so (#83)", {
  local_mocked_bindings(
    CommentIssueRaw = function(...) stop("Should not be called"),
    UpdateIssueComment = function(...) "Success"
  )
  test_result <- CommentIssue(
    intIssue = 1,
    strTitle = "Test Title",
    strBody = "This is a test comment.",
    lglUpdate = TRUE,
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    "Success"
  )
})

test_that("UpdateIssueComment updates when a comment exists (#83)", {
  local_mocked_bindings(
    FetchIssueCommentGHID = function(...) 12345,
    UpdateCommentRaw = function(...) "Success",
    CommentIssueRaw = function(...) stop("Should not be called")
  )
  test_result <- UpdateIssueComment(
    intIssue = 1,
    strBodyCompiled = "Updated comment body.",
    strCommentID = "test-comment-id",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    "Success"
  )
})

test_that("UpdateIssueComment creates when a comment doesn't exist (#83)", {
  local_mocked_bindings(
    FetchIssueCommentGHID = function(...) double(),
    UpdateCommentRaw = function(...) stop("Should not be called"),
    CommentIssueRaw = function(...) "Success"
  )
  test_result <- UpdateIssueComment(
    intIssue = 1,
    strBodyCompiled = "Updated comment body.",
    strCommentID = "test-comment-id",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    "Success"
  )
})

test_that("FetchIssueCommentGHID returns the correct GH ID when found (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(
        list(id = 11111, body = "Some other comment."),
        list(
          id = 22222,
          body = "## Title\n\nBody\n\n<!-- qcthat-comment-id: test-comment-id -->"
        ),
        list(id = 33333, body = "Another comment.")
      )
    }
  )
  test_result <- FetchIssueCommentGHID(
    intIssue = 1,
    strCommentID = "test-comment-id",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    22222
  )
})

test_that("FetchIssueCommentGHID returns nothing when no matching comment found (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(
        list(id = 11111, body = "Some other comment."),
        list(
          id = 22222,
          body = "Also not the comment."
        ),
        list(id = 33333, body = "Another comment.")
      )
    }
  )
  test_result <- FetchIssueCommentGHID(
    intIssue = 1,
    strCommentID = "nonexistent-comment-id",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_equal(
    test_result,
    double()
  )
})

test_that("UpdateCommentRaw calls the API as expected (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  test_result <- UpdateCommentRaw(
    dblCommentGHID = 12345,
    strBodyCompiled = "Updated comment body.",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_named(
    test_result,
    c("", "strOwner", "strRepo", "comment_id", "body", "strGHToken")
  )
  expect_equal(
    test_result[[1]],
    "PATCH /repos/{owner}/{repo}/issues/comments/{comment_id}"
  )
})

test_that("CommentIssueRaw calls the API as expected (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  test_result <- CommentIssueRaw(
    intIssue = 12345,
    strBodyCompiled = "New comment body.",
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
  expect_named(
    test_result,
    c("", "strOwner", "strRepo", "issue_number", "body", "strGHToken")
  )
  expect_equal(
    test_result[[1]],
    "POST /repos/{owner}/{repo}/issues/{issue_number}/comments"
  )
})

test_that("CommentIssue updates a comment as expected (#83)", {
  ExpectUserAccepts(
    c(
      "A new comment appears on the targeted issue.",
      "The comment updates when you re-comment"
    ),
    intIssue = 83,
    chrInstructions = 'Run this code. Make sure `strTitle` is unique, for example by changing "My" to your name.

```r
# Make this semi-unique, so it definitely will not use an existing comment.
strTitle <- "My Test Comment"
CommentIssue(
  83,
  strTitle = strTitle
  strBody = "This is a test comment created for testing purposes."
)
```

After confirming that step, run this code to update the comment.

```r
CommentIssue(
  83,
  strTitle = strTitle
  strBody = "This is an update to an existing comment."
)
```'
  )
})
