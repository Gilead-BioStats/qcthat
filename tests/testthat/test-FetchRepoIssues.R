test_that("FetchRepoIssues returns an empty df when no issues found (#34)", {
  local_mocked_bindings(
    FetchRawRepoIssues = function(...) list()
  )
  test_result <- FetchRepoIssues()
  expect_s3_class(test_result, "qcthat_Issues")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expect_equal(
    test_result,
    tibble::tibble(
      Issue = integer(0),
      Title = character(0),
      Body = character(0),
      Labels = list(),
      State = character(0),
      StateReason = character(0),
      Milestone = character(0),
      Type = character(0),
      Url = character(0),
      ParentOwner = character(0),
      ParentRepo = character(0),
      ParentNumber = integer(0),
      CreatedAt = as.POSIXct(character(0)),
      ClosedAt = as.POSIXct(character(0))
    )
  )
})

test_that("FetchRepoIssues returns a formatted df for real issues (#34)", {
  local_mocked_bindings(
    FetchRawRepoIssues = function(...) GenerateRawRepoIssues()
  )
  test_result <- FetchRepoIssues()
  expect_s3_class(test_result, "qcthat_Issues")
  expect_s3_class(test_result, "tbl_df")
  class(test_result) <- class(tibble::tibble())
  expected_result <- tibble::tibble(
    Issue = c(1L, 2L, 4L, 5L, 6L, 7L, 8L, 9L, 10L),
    Title = paste("Issue number", .data$Issue),
    Body = paste("This is the body of issue number", .data$Issue),
    Labels = list(NULL, "x", "x", NULL, "x", NULL, "x", NULL, "x"),
    State = c(rep("open", 4), "closed", rep("open", 2), "closed", "open"),
    StateReason = dplyr::if_else(.data$State == "closed", "completed", NA),
    Milestone = c(NA, NA, "Milestone 1", NA, NA, NA, "Milestone 2", NA, NA),
    Type = c(
      "Issue",
      "Issue",
      "Issue",
      "Issue",
      "Feature",
      "Issue",
      "Issue",
      "Feature",
      "Issue"
    ),
    Url = paste0(
      "https://github.com/Gilead-BioStats/fakerepo/issues/",
      .data$Issue
    ),
    ParentOwner = NA_character_,
    ParentRepo = NA_character_,
    ParentNumber = NA_integer_,
    CreatedAt = as.POSIXct(NA, tz = "UTC"),
    ClosedAt = as.POSIXct(
      dplyr::if_else(.data$State == "closed", "2025-10-16 15:53:00", NA),
      tz = "UTC"
    )
  )
  expect_equal(test_result, expected_result)
})

test_that("FetchRepoIssues fetch all repo issues (#47)", {
  # This is a kinda convoluted test, but basically I just have to make sure I
  # haven't removed the `.limit` param.
  local_mocked_bindings(
    CallGHAPI = function(.limit, ...) {
      stopifnot(
        .limit == Inf
      )
    }
  )
  expect_no_error(FetchRepoIssues())
})
