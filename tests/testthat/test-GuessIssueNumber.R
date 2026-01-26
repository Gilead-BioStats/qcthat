test_that("GuessIssueNumber returns NULL for bad arg", {
  expect_null(GuessIssueNumber(NULL))
  expect_null(GuessIssueNumber(letters))
  expect_null(GuessIssueNumber(list()))
})

test_that("GuessIssueNumber extracts issue number from lGHEventPayload when available", {
  expect_equal(
    GuessIssueNumber(list(issue = list(number = 42))),
    42
  )
})

test_that("GuessIssueNumber returns NULL for bad extracted issue number", {
  expect_null(GuessIssueNumber(list(issue = list(number = "a"))))
})
