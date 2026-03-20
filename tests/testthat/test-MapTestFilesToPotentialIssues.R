test_that("MapTestFilesToPotentialIssues finds potential issues via commits (#53, #201)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      expect_equal(strTestDir, "tests/testthat")
      tibble::tibble(
        Test = c("Test for issue 1", "Test for issue 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 10L),
        LineEnd = c(5L, 15L),
        Issues = list(integer(), integer()),
        TaggedNoIssue = c(FALSE, FALSE)
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list(c("commit1", "commit2"), c("commit2", "commit3"))
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = 1:2,
        Commits = list(c("commit1", "commit2"), c("commit3"))
      )
    },
    GetPkgRoot = function(strPkgRoot) strPkgRoot
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = c("Test for issue 1", "Test for issue 2"),
    File = c("test-example.R", "test-example.R"),
    LineStart = c(1L, 10L),
    LineEnd = c(5L, 15L),
    Issues = list(integer(), integer()),
    PotentialIssues = list(1L, 1:2)
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues filters out tests tagged with #noissue (#53)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = c("Test with issue", "Test without issue (#noissue)"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 10L),
        LineEnd = c(5L, 15L),
        Issues = list(integer(), integer()),
        TaggedNoIssue = c(FALSE, TRUE)
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list("commit1", "commit1")
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = 1L,
        Commits = list("commit1")
      )
    },
    GetPkgRoot = function(strPkgRoot) strPkgRoot
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = "Test with issue",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    PotentialIssues = list(1L)
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues handles tests with no matching commits (#53)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = "Test with no matches",
        File = "test-example.R",
        LineStart = 1L,
        LineEnd = 5L,
        Issues = list(integer()),
        TaggedNoIssue = FALSE
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list("commit1")
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = 1L,
        Commits = list("commit2")
      )
    },
    GetPkgRoot = function(strPkgRoot) strPkgRoot
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = "Test with no matches",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    PotentialIssues = list(integer())
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues handles tests with tagged issues (#53)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = "Test for issue 1 (#1)",
        File = "test-example.R",
        LineStart = 1L,
        LineEnd = 5L,
        Issues = list(1L),
        TaggedNoIssue = FALSE
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list(c("commit1", "commit2"))
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = c(1L, 2L),
        Commits = list("commit1", "commit2")
      )
    },
    GetPkgRoot = function(strPkgRoot) strPkgRoot
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = "Test for issue 1 (#1)",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(1L),
    PotentialIssues = list(c(1L, 2L))
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues handles empty test directory (#265)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = character(),
        File = character(),
        LineStart = integer(),
        LineEnd = integer(),
        Issues = vctrs::list_of(.ptype = integer()),
        TaggedNoIssue = logical()
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(dfFileTests, Commits = vctrs::list_of(.ptype = character()))
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = integer(),
        Commits = vctrs::list_of(.ptype = character())
      )
    }
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    PotentialIssues = vctrs::list_of(.ptype = integer())
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues handles all tests tagged with #noissue (#265)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = c("Test 1 (#noissue)", "Test 2 (#noissue)"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 10L),
        LineEnd = c(5L, 15L),
        Issues = list(integer(), integer()),
        TaggedNoIssue = c(TRUE, TRUE)
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list("commit1", "commit2")
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = 1L,
        Commits = list("commit1")
      )
    }
  )
  dfResult <- MapTestFilesToPotentialIssues()
  dfExpected <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    PotentialIssues = vctrs::list_of(.ptype = integer())
  )
  expect_identical(dfResult, dfExpected)
})

test_that("MapTestFilesToPotentialIssues passes strTestDir parameter (#265)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      expect_equal(strTestDir, "custom/test/dir")
      tibble::tibble(
        Test = character(),
        File = character(),
        LineStart = integer(),
        LineEnd = integer(),
        Issues = list(),
        TaggedNoIssue = logical()
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(dfFileTests, Commits = list())
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(Issue = integer(), Commits = list())
    }
  )
  dfResult <- MapTestFilesToPotentialIssues(strTestDir = "custom/test/dir")
  expect_s3_class(dfResult, "tbl_df")
})

test_that("MapTestFilesToPotentialIssues passes GitHub parameters (#265)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = character(),
        File = character(),
        LineStart = integer(),
        LineEnd = integer(),
        Issues = list(),
        TaggedNoIssue = logical()
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(dfFileTests, Commits = list())
    }
  )
  dfResult <- MapTestFilesToPotentialIssues(
    strOwner = "testowner",
    strRepo = "testrepo",
    strGHToken = "testtoken"
  )
  expect_s3_class(dfResult, "tbl_df")
})

test_that("MapTestFilesToPotentialIssues merges source coverage issues when lglUseCoverage = TRUE (#265)", {
  local_mocked_bindings(
    ExtractTestsFromFiles = function(strTestDir) {
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(integer(), integer()),
        TaggedNoIssue = c(FALSE, FALSE)
      )
    },
    MapTestsToCommits = function(dfFileTests) {
      dplyr::mutate(
        dfFileTests,
        Commits = list("commit1", "commit2")
      )
    },
    MapRepoIssuesToCommits = function(...) {
      tibble::tibble(
        Issue = 1:2,
        Commits = list("commit1", "commit2")
      )
    },
    GetPkgRoot = function(strPkgRoot, ...) strPkgRoot,
    LoadPkgEnv = function(strTestDir, ...) new.env(),
    MapTestsToCoveredLines = function(
      envPkg,
      dfFileTests,
      strTestDir,
      envCall
    ) {
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(integer(), integer()),
        SourceFile = c("R/foo.R", "R/bar.R"),
        Line = c(10L, 5L)
      )
    },
    MapCoveredLinesToPotentialIssues = function(
      dfTestCoveredLines,
      dfIssueCommitsLong
    ) {
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(integer(), integer()),
        PotentialIssues = list(c(1L, 3L), 4L)
      )
    }
  )
  dfResult <- MapTestFilesToPotentialIssues(lglUseCoverage = TRUE)
  # Test 1: git-blame had issue 1, source coverage added 1 and 3 → merged = 1, 3
  dfTest1 <- dfResult[dfResult$Test == "Test 1", ]
  expect_identical(dfTest1$PotentialIssues[[1]], c(1L, 3L))
  # Test 2: git-blame had issue 2, source coverage added 4 → merged = 2, 4
  dfTest2 <- dfResult[dfResult$Test == "Test 2", ]
  expect_identical(dfTest2$PotentialIssues[[1]], c(2L, 4L))
})

test_that("AugmentPotentialIssuesFromCoverage() passes strTestDir to LoadPkgEnv (#265)", {
  local_mocked_bindings(
    LoadPkgEnv = function(strTestDir, ...) {
      expect_equal(strTestDir, "custom/test/dir")
      new.env()
    },
    MapTestsToCoveredLines = function(
      envPkg,
      dfFileTests,
      strTestDir,
      envCall
    ) {
      EmptyTestCoveredLinesDF()
    },
    MapCoveredLinesToPotentialIssues = function(
      dfTestCoveredLines,
      dfIssueCommitsLong
    ) {
      EmptyTestPotentialIssues()
    }
  )
  dfTestBlame <- tibble::tibble(
    Test = "Test 1",
    File = "test-example.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    PotentialIssues = list(integer())
  )
  AugmentPotentialIssuesFromCoverage(
    dfTestBlame = dfTestBlame,
    dfFileTests = NULL,
    dfIssueCommitsLong = tibble::tibble(Issue = integer(), Commits = list()),
    strTestDir = "custom/test/dir"
  )
})

test_that("AugmentPotentialIssuesFromCoverage() merges coverage issues with commit-based issues (#265)", {
  local_mocked_bindings(
    LoadPkgEnv = function(strTestDir, ...) new.env(),
    MapTestsToCoveredLines = function(
      envPkg,
      dfFileTests,
      strTestDir,
      envCall
    ) {
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(integer(), integer()),
        SourceFile = c("R/foo.R", "R/bar.R"),
        Line = c(10L, 5L)
      )
    },
    MapCoveredLinesToPotentialIssues = function(
      dfTestCoveredLines,
      dfIssueCommitsLong
    ) {
      tibble::tibble(
        Test = c("Test 1", "Test 2"),
        File = c("test-example.R", "test-example.R"),
        LineStart = c(1L, 5L),
        LineEnd = c(3L, 7L),
        Issues = list(integer(), integer()),
        PotentialIssues = list(c(1L, 3L), 4L)
      )
    }
  )
  dfTestBlame <- tibble::tibble(
    Test = c("Test 1", "Test 2"),
    File = c("test-example.R", "test-example.R"),
    LineStart = c(1L, 5L),
    LineEnd = c(3L, 7L),
    Issues = list(integer(), integer()),
    PotentialIssues = list(1L, 2L)
  )
  dfResult <- AugmentPotentialIssuesFromCoverage(
    dfTestBlame = dfTestBlame,
    dfFileTests = NULL,
    dfIssueCommitsLong = tibble::tibble(
      Issue = 1:4,
      Commits = list("commit1", "commit2", "commit3", "commit4")
    ),
    strTestDir = "tests/testthat"
  )
  # Test 1: commit-based had issue 1; coverage added 1 and 3 → merged = 1, 3
  expect_identical(dfResult$PotentialIssues[[1]], c(1L, 3L))
  # Test 2: commit-based had issue 2; coverage added 4 → merged = 2, 4
  expect_identical(dfResult$PotentialIssues[[2]], c(2L, 4L))
})
