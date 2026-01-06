test_that("ExpectUserAccepts returns the input strDescription", {
  local_mocked_bindings(
    OnCran = function() TRUE
  )
  strDescription <- "The thing renders"
  chrChecks <- c("check1", "check2")
  result <- ExpectUserAccepts(
    strDescription,
    intIssue = 12L,
    chrChecks = chrChecks
  )
  expect_identical(result, strDescription)
})

test_that("ExpectUserAccepts passes when the issue is closed", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "closed", Url = "http://example.com/issue/123")
    },
    IsOnline = function() TRUE
  )
  local_dfUATIssues()
  expect_success({
    ExpectUserAccepts(
      strDescription = "The thing renders",
      intIssue = 12L,
      chrChecks = c("check1", "check2"),
      strOwner = "owner",
      strRepo = "repo"
    )
  })
})

test_that("ExpectUserAccepts fails when the issue isn't closed and strFailureMode is 'fail'", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    },
    IsOnline = function() TRUE
  )
  local_dfUATIssues()
  expect_failure(
    {
      ExpectUserAccepts(
        strDescription = "The thing renders",
        intIssue = 12L,
        chrChecks = c("check1", "check2"),
        strFailureMode = "fail",
        strOwner = "owner",
        strRepo = "repo"
      )
    },
    "http://example.com/issue/123"
  )
})

test_that("ExpectUserAccepts returns silently when the issue isn't closed and strFailureMode is 'ignore'", {
  local_mocked_bindings(
    OnCran = function() FALSE,
    UsesGit = function() TRUE,
    FetchUAIssue = function(...) {
      list(State = "open", Url = "http://example.com/issue/123")
    }
  )
  local_dfUATIssues()
  chrChecks <- c("check1", "check2")
  strDescription <- "The thing renders"
  result <- ExpectUserAccepts(
    strDescription = strDescription,
    intIssue = 12L,
    chrChecks = chrChecks,
    strOwner = "owner",
    strRepo = "repo"
  )
  expect_identical(result, strDescription)
})

test_that("OnCran returns FALSE when envvar unset or true (#113)", {
  withr::local_envvar(list(NOT_CRAN = ""))
  expect_false(OnCran())
  withr::local_envvar(list(NOT_CRAN = "true"))
  expect_false(OnCran())
})

test_that("OnCran returns TRUE when envvar set to false (#113)", {
  withr::local_envvar(list(NOT_CRAN = "false"))
  expect_true(OnCran())
})

test_that("LogUAT logs UAT status (#115)", {
  local_dfUATIssues()

  strRandom1 <- paste(sample(letters, 32, replace = TRUE), collapse = "")
  strRandom2 <- paste(sample(letters, 32, replace = TRUE), collapse = "")
  dttmTSBase <- as.POSIXct("2025-12-19 08:28:00", tz = "UTC")

  LogUAT(
    intParentIssue = 10L,
    intUATIssue = 20L,
    strDescription = strRandom1,
    strDisposition = "pending",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10L,
      UATIssue = 20L,
      Description = strRandom1,
      Disposition = "pending",
      Owner = "owner",
      Repo = "repo",
      Timestamp = dttmTSBase
    )
  )
  LogUAT(
    intParentIssue = 11L,
    intUATIssue = 21L,
    strDescription = strRandom2,
    strDisposition = "pending",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase + 1
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10:11,
      UATIssue = 20:21,
      Description = c(strRandom1, strRandom2),
      Disposition = c("pending", "pending"),
      Owner = "owner",
      Repo = "repo",
      Timestamp = c(dttmTSBase, dttmTSBase + 1)
    )
  )
  LogUAT(
    intParentIssue = 10L,
    intUATIssue = 20L,
    strDescription = strRandom1,
    strDisposition = "accepted",
    strOwner = "owner",
    strRepo = "repo",
    dttmTimestamp = dttmTSBase + 2
  )
  expect_equal(
    envQcthat$UATIssues,
    tibble::tibble(
      ParentIssue = 10:11,
      UATIssue = 20:21,
      Description = c(strRandom1, strRandom2),
      Disposition = c("accepted", "pending"),
      Owner = "owner",
      Repo = "repo",
      Timestamp = c(dttmTSBase + 2, dttmTSBase + 1)
    ) |>
      dplyr::arrange(.data$Timestamp)
  )
})
