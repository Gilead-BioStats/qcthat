withr::local_options(list(GITHUB_RUN_ID = ""))

test_that("CommentReport generates the expected call (#99)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...),
    FormatSessionInfo = function() ""
  )
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})

test_that("CommentReport includes run URL when available (#150)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...),
    FetchRunURL = function(strRunID, ...) {
      switch(
        strRunID,
        "no_jobs" = "https://link.to.run",
        "with_job" = "https://link.to.run/job/id",
        NULL
      )
    },
    FormatSessionInfo = function() ""
  )
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strRunID = "no_jobs",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strRunID = "with_job",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strRunID = "bad_run",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})

test_that("FetchRunURL returns the expected URL (#150)", {
  local_mocked_bindings(
    FetchRunJobsRaw = function(strRunID, ...) {
      switch(
        strRunID,
        "one_job" = list(
          total_count = 1,
          jobs = list(list(html_url = "https://link.to.run/job/1"))
        ),
        "two_jobs" = list(
          total_count = 2,
          jobs = list(list(a = "a"), list(b = "b"))
        ),
        "no_jobs" = list(total_count = 0)
      )
    },
    FetchRunInfoRaw = function(strRunID, ...) {
      switch(
        strRunID,
        "two_jobs" = list(html_url = "https://link.to.run/with_jobs"),
        "no_jobs" = list(html_url = "https://link.to.run/no_jobs")
      )
    }
  )
  expect_equal(
    FetchRunURL(
      "one_job",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "https://link.to.run/job/1"
  )
  expect_equal(
    FetchRunURL(
      "two_jobs",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "https://link.to.run/with_jobs"
  )
  expect_equal(
    FetchRunURL(
      "no_jobs",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    ),
    "https://link.to.run/no_jobs"
  )
})

test_that("FetchRunJobsRaw makes the expected call (#150)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  expect_snapshot({
    FetchRunJobsRaw(
      "run_id",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})

test_that("FetchRunInfoRaw makes the expected call (#150)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  expect_snapshot({
    FetchRunInfoRaw(
      "run_id",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})

test_that("CommentReport includes session info (#150)", {
  local_mocked_bindings(
    CommentIssue = function(...) list(...),
    GetRawSessionInfo = function() "Raw session info"
  )
  dfRepoIssues <- GenerateSampleDFRepoIssues()
  dfTestResults <- GenerateSampleDFTestResults()
  dfITM <- CompileIssueTestMatrix(
    dfRepoIssues = dfRepoIssues,
    dfTestResults = dfTestResults
  )
  expect_snapshot({
    CommentReport(
      dfITM,
      strReportType = "Testing",
      intPRNumber = 99,
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})
