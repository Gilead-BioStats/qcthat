test_that("FetchRepoPRs returns an empty df when no issues found (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list()
  )
  test_result <- FetchRepoPRs("someowner", "myrepo", "mytoken")
  expect_s3_class(test_result, "qcthat_PRs")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expect_equal(
    test_result,
    tibble::tibble(
      PR = integer(),
      Title = character(),
      State = character(),
      HeadRef = character(),
      BaseRef = character(),
      Body = character(),
      MergeCommitSHA = character(),
      IsDraft = logical(),
      Url = character(),
      CreatedAt = as.POSIXct(character()),
      ClosedAt = as.POSIXct(character()),
      MergedAt = as.POSIXct(character())
    )
  )
})

test_that("FetchRepoPRs returns a formatted df for real PRs (#84)", {
  local_mocked_bindings(
    CallGHAPI = function(...) GenerateRawRepoPRs()
  )
  test_result <- FetchRepoPRs("someowner", "myrepo", "mytoken")
  expect_s3_class(test_result, "qcthat_PRs")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expected_result <- tibble::tibble(
    PR = 1:5,
    Title = paste("PR number", .data$PR),
    State = c("open", "open", "closed", "open", "open"),
    HeadRef = paste0("headref", .data$PR),
    BaseRef = paste0("baseref", .data$PR),
    Body = paste("This is the body of PR number", .data$PR),
    MergeCommitSHA = c(NA, NA, "mergesha3", NA, NA),
    IsDraft = c(FALSE, FALSE, FALSE, FALSE, TRUE),
    Url = paste0("https://github.com/Gilead-BioStats/fakerepo/PRs/", .data$PR),
    CreatedAt = as.POSIXct("2025-10-15 12:34:00", tz = "UTC"),
    ClosedAt = as.POSIXct(
      dplyr::if_else(.data$State == "closed", "2025-10-16 15:53:00", NA),
      tz = "UTC"
    ),
    MergedAt = as.POSIXct(
      dplyr::if_else(.data$State == "closed", "2025-10-16 15:53:00", NA),
      tz = "UTC"
    )
  )
  expect_equal(test_result, expected_result)
})
