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
      PR = integer(0),
      Title = character(0),
      State = character(0),
      HeadRef = character(0),
      BaseRef = character(0),
      Body = character(0),
      MergeCommitSHA = character(0),
      IsDraft = logical(0),
      Url = character(0),
      CreatedAt = as.POSIXct(character(0)),
      ClosedAt = as.POSIXct(character(0)),
      MergedAt = as.POSIXct(character(0))
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
