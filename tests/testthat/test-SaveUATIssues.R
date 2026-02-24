test_that("SaveUATIssues saves UAT issues and LoadUATIssues loads them (#164)", {
  local_dfUATIssues()
  envQcthat$UATIssues <- tibble::tibble(
    ParentIssue = 1:3,
    UATIssue = 4:6,
    Description = paste(
      "Description of",
      .data$UATIssue,
      "for",
      .data$ParentIssue
    ),
    Disposition = c("pending", "accepted", "pending"),
    Owner = "owner",
    Repo = "repo",
    Timestamp = as.POSIXct(1:3, tzone = "UTC", origin = "1970-01-01")
  )
  path <- withr::local_tempfile(fileext = ".rds")
  expect_no_error(SaveUATIssues(path))
  test_result <- readRDS(path)
  expect_identical(test_result, envQcthat$UATIssues)
  envQcthat$UATIssues <- tibble::tibble()
  LoadUATIssues(path)
  expect_identical(envQcthat$UATIssues, test_result)
})
