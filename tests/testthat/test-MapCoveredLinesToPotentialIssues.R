test_that("MapCoveredLinesToPotentialIssues maps source blame to issues (#265)", {
  dfTestCoveredLines <- tibble::tibble(
    Test = c("test A", "test A", "test B"),
    File = c("test-foo.R", "test-foo.R", "test-foo.R"),
    LineStart = c(1L, 1L, 10L),
    LineEnd = c(5L, 5L, 15L),
    Issues = list(integer(), integer(), integer()),
    SourceFile = c("R/foo.R", "R/bar.R", "R/foo.R"),
    Line = c(10L, 5L, 10L)
  )
  local_mocked_bindings(
    BlameFileRaw = function(strFilePath, envCall = rlang::caller_env()) {
      if (grepl("foo.R$", strFilePath)) {
        list(
          hunks = list(
            list(
              final_commit_id = "commit1",
              final_start_line_number = 1L,
              lines_in_hunk = 20L
            )
          )
        )
      } else {
        list(
          hunks = list(
            list(
              final_commit_id = "commit2",
              final_start_line_number = 1L,
              lines_in_hunk = 10L
            )
          )
        )
      }
    },
    GetRelativePackagePath = function(strFilePath, envCall) strFilePath
  )
  dfIssueCommitsLong <- tibble::tibble(
    Issue = c(1L, 2L),
    Commits = c("commit1", "commit2")
  )
  dfResult <- MapCoveredLinesToPotentialIssues(
    dfTestCoveredLines,
    dfIssueCommitsLong
  )
  expect_s3_class(dfResult, "tbl_df")
  expect_named(
    dfResult,
    c("Test", "File", "LineStart", "LineEnd", "Issues", "PotentialIssues")
  )
  dfTestA <- dfResult[dfResult$Test == "test A", ]
  expect_identical(dfTestA$PotentialIssues, list(1:2))
  dfTestB <- dfResult[dfResult$Test == "test B", ]
  expect_identical(dfTestB$PotentialIssues, list(1L))
})

test_that("MapCoveredLinesToPotentialIssues handles empty input (#265)", {
  dfTestCoveredLines <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    SourceFile = character(),
    Line = integer()
  )
  dfIssueCommitsLong <- tibble::tibble(
    Issue = integer(),
    Commits = character()
  )
  dfResult <- MapCoveredLinesToPotentialIssues(
    dfTestCoveredLines,
    dfIssueCommitsLong
  )
  expect_identical(nrow(dfResult), 0L)
  expect_named(
    dfResult,
    c("Test", "File", "LineStart", "LineEnd", "Issues", "PotentialIssues")
  )
})

test_that("MergePotentialIssues unions and deduplicates (#265)", {
  dfTestBlame <- tibble::tibble(
    Test = c("test A", "test B"),
    File = c("test-foo.R", "test-foo.R"),
    LineStart = c(1L, 10L),
    LineEnd = c(5L, 15L),
    Issues = list(integer(), integer()),
    PotentialIssues = list(c(1L, 2L), 3L)
  )
  dfSourceBlame <- tibble::tibble(
    Test = c("test A", "test B"),
    File = c("test-foo.R", "test-foo.R"),
    LineStart = c(1L, 10L),
    LineEnd = c(5L, 15L),
    Issues = list(integer(), integer()),
    PotentialIssues = list(c(2L, 3L), c(3L, 4L))
  )
  dfResult <- MergePotentialIssues(dfTestBlame, dfSourceBlame)
  expect_identical(dfResult$Test, c("test A", "test B"))
  expect_identical(dfResult$PotentialIssues, list(1:3, 3:4))
})

test_that("MergePotentialIssues handles one empty side (#265)", {
  dfTestBlame <- tibble::tibble(
    Test = "test A",
    File = "test-foo.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    PotentialIssues = list(c(1L, 2L))
  )
  dfEmpty <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    PotentialIssues = vctrs::list_of(.ptype = integer())
  )
  dfResult <- MergePotentialIssues(dfTestBlame, dfEmpty)
  expect_identical(dfResult$PotentialIssues, list(1:2))
})
