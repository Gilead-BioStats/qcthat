test_that("CommentUAT generates the expected call with 0 pending issues (#115)", {
  local_mocked_bindings(
    FetchPRIssueNumbers = function(...) integer(),
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

test_that("CommentUAT generates the expected call (#115, #185)", {
  local_mocked_bindings(
    FetchPRIssueNumbers = function(...) 1:3,
    CommentIssue = function(...) list(...)
  )
  local_dfUATIssues()
  envQcthat$UATIssues <- tibble::tibble(
    ParentIssue = 1:4,
    UATIssue = 5:8,
    Description = paste("Description of", 1:4),
    Disposition = c("pending", "accepted", "pending", "accepted"),
    Owner = "owner",
    Repo = "repo",
    Timestamp = as.POSIXct(1:4, tz = "UTC", origin = "2026-01-01")
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

test_that("FormatUATGH works for errors (#137, #185, #230)", {
  local_dfUATIssues()
  envQcthat$UATIssues <- tibble::tibble(
    ParentIssue = 1:4,
    UATIssue = 5:8,
    Description = paste("Description of", 1:4),
    Disposition = c("pending", "accepted", "error", "failed_to_create"),
    Owner = "owner",
    Repo = "repo",
    Timestamp = as.POSIXct(1:4, tz = "UTC", origin = "2026-01-01")
  )
  expect_snapshot({
    cat(FormatUATGH(1:4))
  })
})

test_that("CommentUAT includes accepted UAT for this PR (#185)", {
  # Manually skip so we can do the `if` below. Consider adding helpers for this
  # situation! This is twice now that I've needed it!
  skip_if(OnCran())
  skip_if_not(UsesGit())
  skip_if_not(IsOnline())

  lUAT1 <- list(
    description = "This issue remains visible",
    intIssue = 185,
    chrInstructions = "Accept this UAT issue to see that it remains in the comment."
  )

  qcthat::ExpectUserAccepts(
    lUAT1$description,
    intIssue = lUAT1$intIssue,
    chrInstructions = lUAT1$chrInstructions
  )

  # Only run this one if the first one is closed.
  lUAIssue <- with_mocked_bindings(
    {
      FetchUAIssue(
        lUAT1$description,
        intIssue = lUAT1$intIssue,
        chrInstructions = lUAT1$chrInstructions
      )
    },
    CreateUAIssue = function(...) list()
  )
  if (identical(lUAIssue[["State"]], "closed")) {
    qcthat::ExpectUserAccepts(
      "The issue above remains visible",
      intIssue = lUAT1$intIssue,
      chrInstructions = "If the *other* issue remained visible after it was accepted and the action re-ran, accept this issue."
    )
  }
})
