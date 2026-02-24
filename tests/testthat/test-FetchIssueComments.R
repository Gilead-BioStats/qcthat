test_that("FetchIssueComments returns an empty df when no issues found (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list()
  )
  test_result <- FetchIssueComments(42, "someowner", "myrepo", "mytoken")
  expect_s3_class(test_result, "qcthat_Comments")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expect_equal(
    test_result,
    tibble::tibble(
      Body = character(),
      Url = character(),
      CommentGHID = double(),
      Author = character(),
      CreatedAt = as.POSIXct(character()),
      UpdatedAt = as.POSIXct(character()),
      qcthatCommentID = character()
    )
  )
})

test_that("FetchIssueComments returns a formatted df for real issues (#83)", {
  local_mocked_bindings(
    CallGHAPI = function(...) GenerateRawIssueComments()
  )
  test_result <- FetchIssueComments("someowner", "myrepo", "mytoken")
  expect_s3_class(test_result, "qcthat_Comments")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expected_result <- tibble::tibble(
    Body = paste("This is the body of comment number", 1:5),
    Url = paste0("https://fake.api.com/", 1:5),
    CommentGHID = 1:5,
    Author = paste0("user", 1:5),
    CreatedAt = as.POSIXct("2025-10-15 12:34:00", tz = "UTC"),
    UpdatedAt = as.POSIXct("2025-10-16 15:53:00", tz = "UTC"),
    qcthatCommentID = c(NA, rlang::hash(2L), NA, rlang::hash(4L), NA)
  )
  expected_result$Body[c(2, 4)] <- paste(
    expected_result$Body[c(2, 4)],
    "with qcthat-comment-id:",
    c(rlang::hash(2L), rlang::hash(4L))
  )
  expect_equal(test_result, expected_result)
})
