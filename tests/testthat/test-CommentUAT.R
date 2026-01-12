test_that("CommentUAT generates the expected call with 0 pending issues (#115)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...)
  )
  local_dfUATIssues()
  test_result <- CommentUAT(
    intPRNumber = 99,
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expect_equal(test_result[[1]], 99)
  expect_equal(
    test_result$strTitle,
    "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance"
  )
  expect_equal(test_result$strBody, "No issues are awaiting UAT.")
})

test_that("CommentUAT generates the expected call (#115)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...)
  )
  local_dfUATIssues()
  envQcthat$UATIssues <- tibble::tibble(
    ParentIssue = 1:3,
    UATIssue = 4:6,
    Description = paste("Description of", 1:3),
    Disposition = c("pending", "accepted", "pending"),
    Owner = "owner",
    Repo = "repo",
    Timestamp = as.POSIXct(1:3, tz = "UTC")
  )
  test_result <- CommentUAT(
    intPRNumber = 99,
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expect_equal(test_result[[1]], 99)
  expect_equal(
    test_result$strTitle,
    "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance"
  )
  expect_snapshot({
    cat(test_result$strBody)
  })
})
