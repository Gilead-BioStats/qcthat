test_that("FetchRepoIssues returns an empty df when no issues found (#34)", {
  local_mocked_bindings(
    .FetchRawRepoIssues = function(...) list()
  )
  expect_equal(
    FetchRepoIssues(),
    tibble::tibble(
      Number = integer(0),
      Title = character(0),
      Labels = list(),
      Status = character(0),
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
    .FetchRawRepoIssues = function(...) {
      GenerateRawRepoIssues()
    }
  )
  expected_result <- tibble::tibble(
    Number = c(1L, 2L, 4L, 5L, 6L, 7L, 8L, 9L, 10L),
    Title = paste("Issue number", .data$Number),
    Labels = list(NULL, "x", "x", NULL, "x", NULL, "x", NULL, "x"),
    Status = c(rep("open", 4), "closed", rep("open", 2), "closed", "open"),
    StateReason = dplyr::if_else(
      .data$Status == "closed",
      "completed",
      NA
    ),
    Milestone = c(NA, NA, "Milestone 1", NA, NA, NA, "Milestone 2", NA, NA),
    Type = c(NA, NA, NA, NA, "Feature", NA, NA, "Feature", NA),
    Url = paste0(
      "https://github.com/Gilead-BioStats/fakerepo/issues/",
      .data$Number
    ),
    ParentOwner = NA_character_,
    ParentRepo = NA_character_,
    ParentNumber = NA_character_,
    CreatedAt = as.POSIXct(NA, tz = "UTC"),
    ClosedAt = as.POSIXct(
      dplyr::if_else(
        .data$Status == "closed",
        "2025-10-16 15:53:00",
        NA
      ),
      tz = "UTC"
    )
  )
  expect_equal(
    FetchRepoIssues(),
    expected_result
  )
})
