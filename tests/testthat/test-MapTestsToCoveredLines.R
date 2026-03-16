test_that("ReadTestFileContents reads unique files into named list (#265)", {
  dfFileTests <- tibble::tibble(
    File = c(
      test_path("fixtures", "testFiles", "test-example1.R"),
      test_path("fixtures", "testFiles", "test-example1.R"),
      test_path("fixtures", "testFiles", "test-example2.R")
    )
  )
  result <- ReadTestFileContents(dfFileTests)
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, unique(dfFileTests$File))
  expect_type(result[[1]], "character")
  expect_true(length(result[[1]]) > 0)
})

test_that("ExtractTestWithPreamble includes preamble before first test (#265)", {
  chrFileLines <- c(
    "library(testthat)",
    "my_var <- 42",
    "",
    'test_that("first test", {',
    "  expect_true(TRUE)",
    "})",
    "",
    'test_that("second test", {',
    "  expect_equal(my_var, 42)",
    "})"
  )
  result <- ExtractTestWithPreamble(chrFileLines, 8L, 10L, 4L)
  expected <- c(
    "library(testthat)",
    "my_var <- 42",
    "",
    'test_that("second test", {',
    "  expect_equal(my_var, 42)",
    "})"
  )
  expect_identical(result, expected)
})

test_that("ExtractTestWithPreamble works when test starts at line 1 (#265)", {
  chrFileLines <- c(
    'test_that("only test", {',
    "  expect_true(TRUE)",
    "})"
  )
  result <- ExtractTestWithPreamble(chrFileLines, 1L, 3L, 1L)
  expect_identical(result, chrFileLines)
})

test_that("NormalizeTallyPaths converts absolute paths to relative (#265)", {
  dfTally <- data.frame(
    filename = c(
      "C:/pkg/R/foo.R",
      "C:/pkg/R/foo.R",
      "C:/pkg/R/bar.R"
    ),
    line = c(1L, 5L, 10L),
    value = c(1, 2, 1),
    stringsAsFactors = FALSE
  )
  dfResult <- NormalizeTallyPaths(dfTally, "C:/pkg")
  expect_identical(
    dfResult$SourceFile,
    c("R/foo.R", "R/foo.R", "R/bar.R")
  )
  expect_identical(dfResult$Line, c(1L, 5L, 10L))
  expect_false("filename" %in% names(dfResult))
})

test_that("CoverSingleTest returns covered lines from tally (#265)", {
  local_mocked_bindings(
    CoverSingleTestRaw = function(envPkg, strTempFile) {
      structure(list(), class = "coverage")
    },
    TallyCoverage = function(objCoverage) {
      data.frame(
        filename = c("/pkg/R/foo.R", "/pkg/R/foo.R", "/pkg/R/bar.R"),
        line = c(1L, 5L, 10L),
        value = c(1, 0, 3),
        stringsAsFactors = FALSE
      )
    }
  )
  strTempFile <- tempfile(fileext = ".R")
  writeLines('test_that("x", { expect_true(TRUE) })', strTempFile)
  on.exit(unlink(strTempFile), add = TRUE)

  strTempSnapDir <- tempfile("snaps_")
  dir.create(strTempSnapDir)
  on.exit(unlink(strTempSnapDir, recursive = TRUE), add = TRUE)

  dfResult <- CoverSingleTest(
    envPkg = new.env(),
    strTempFile = strTempFile,
    strPkgRoot = "/pkg",
    strTestFile = "tests/testthat/test-foo.R",
    strTempSnapDir = strTempSnapDir,
    strAbsTestDir = normalizePath(".")
  )
  expect_identical(dfResult$SourceFile, c("R/foo.R", "R/bar.R"))
  expect_identical(dfResult$Line, c(1L, 10L))
})

test_that("CoverSingleTest returns NULL when no lines are covered (#265)", {
  local_mocked_bindings(
    CoverSingleTestRaw = function(envPkg, strTempFile) {
      structure(list(), class = "coverage")
    },
    TallyCoverage = function(objCoverage) {
      data.frame(
        filename = "/pkg/R/foo.R",
        line = 1L,
        value = 0,
        stringsAsFactors = FALSE
      )
    }
  )
  strTempFile <- tempfile(fileext = ".R")
  writeLines('test_that("x", { 1 })', strTempFile)
  on.exit(unlink(strTempFile), add = TRUE)

  strTempSnapDir <- tempfile("snaps_")
  dir.create(strTempSnapDir)
  on.exit(unlink(strTempSnapDir, recursive = TRUE), add = TRUE)

  result <- CoverSingleTest(
    envPkg = new.env(),
    strTempFile = strTempFile,
    strPkgRoot = "/pkg",
    strTestFile = "tests/testthat/test-foo.R",
    strTempSnapDir = strTempSnapDir,
    strAbsTestDir = normalizePath(".")
  )
  expect_null(result)
})

test_that("CoverSingleTest returns NULL on error (#265)", {
  local_mocked_bindings(
    CoverSingleTestRaw = function(envPkg, strTempFile) {
      stop("test failure")
    }
  )
  strTempFile <- tempfile(fileext = ".R")
  writeLines("bad code", strTempFile)
  on.exit(unlink(strTempFile), add = TRUE)

  strTempSnapDir <- tempfile("snaps_")
  dir.create(strTempSnapDir)
  on.exit(unlink(strTempSnapDir, recursive = TRUE), add = TRUE)

  result <- CoverSingleTest(
    envPkg = new.env(),
    strTempFile = strTempFile,
    strPkgRoot = "/pkg",
    strTestFile = "tests/testthat/test-foo.R",
    strTempSnapDir = strTempSnapDir,
    strAbsTestDir = normalizePath(".")
  )
  expect_null(result)
})

test_that("SetupTempSnapDir copies snapshot file to temp dir (#265)", {
  strSnapDir <- withr::local_tempdir()
  writeLines("snapshot content", file.path(strSnapDir, "foo.md"))

  strTempSnapDir <- SetupTempSnapDir(
    "tests/testthat/test-foo.R",
    strSnapDir
  )
  withr::defer(unlink(strTempSnapDir, recursive = TRUE))

  expect_true(dir.exists(strTempSnapDir))
  expect_true(file.exists(file.path(strTempSnapDir, "foo.md")))
  expect_identical(
    readLines(file.path(strTempSnapDir, "foo.md")),
    "snapshot content"
  )
})

test_that("SetupTempSnapDir works when no snapshot file exists (#265)", {
  strSnapDir <- withr::local_tempdir()

  strTempSnapDir <- SetupTempSnapDir(
    "tests/testthat/test-bar.R",
    strSnapDir
  )
  withr::defer(unlink(strTempSnapDir, recursive = TRUE))

  expect_true(dir.exists(strTempSnapDir))
  expect_length(list.files(strTempSnapDir), 0L)
})

test_that("ExtractAllTestCode extracts code for all tests (#265)", {
  dfFileTests <- tibble::tibble(
    File = c("a.R", "a.R"),
    LineStart = c(4L, 8L),
    LineEnd = c(6L, 10L)
  )
  chrFileContents <- list(
    "a.R" = c(
      "library(testthat)",
      "my_var <- 1",
      "",
      'test_that("test A", {',
      "  expect_true(TRUE)",
      "})",
      "",
      'test_that("test B", {',
      "  expect_equal(my_var, 1)",
      "})"
    )
  )
  result <- ExtractAllTestCode(dfFileTests, chrFileContents)
  expect_length(result, 2L)
  expect_identical(
    result[[1]],
    c(
      "library(testthat)",
      "my_var <- 1",
      "",
      'test_that("test A", {',
      "  expect_true(TRUE)",
      "})"
    )
  )
  expect_identical(
    result[[2]],
    c(
      "library(testthat)",
      "my_var <- 1",
      "",
      'test_that("test B", {',
      "  expect_equal(my_var, 1)",
      "})"
    )
  )
})

test_that("ExtractAllTestCode handles namespaced and indented test_that (#265)", {
  dfFileTests <- tibble::tibble(
    File = c("a.R", "a.R"),
    LineStart = c(4L, 8L),
    LineEnd = c(6L, 10L)
  )
  chrFileContents <- list(
    "a.R" = c(
      "library(testthat)",
      "my_var <- 1",
      "",
      '  testthat::test_that("test A", {',
      "    expect_true(TRUE)",
      "  })",
      "",
      '  testthat::test_that("test B", {',
      "    expect_equal(my_var, 1)",
      "  })"
    )
  )
  result <- ExtractAllTestCode(dfFileTests, chrFileContents)
  expect_length(result, 2L)
  expect_identical(
    result[[1]],
    c(
      "library(testthat)",
      "my_var <- 1",
      "",
      '  testthat::test_that("test A", {',
      "    expect_true(TRUE)",
      "  })"
    )
  )
  expect_identical(
    result[[2]],
    c(
      "library(testthat)",
      "my_var <- 1",
      "",
      '  testthat::test_that("test B", {',
      "    expect_equal(my_var, 1)",
      "  })"
    )
  )
})

test_that("WriteAllTempTestFiles writes all files and returns paths (#265)", {
  lstTestCode <- list(
    c("line1", "line2"),
    c("line3")
  )
  chrPaths <- WriteAllTempTestFiles(lstTestCode)
  on.exit(unlink(chrPaths), add = TRUE)

  expect_length(chrPaths, 2L)
  expect_true(all(file.exists(chrPaths)))
  expect_identical(readLines(chrPaths[[1]]), c("line1", "line2"))
  expect_identical(readLines(chrPaths[[2]]), "line3")
})

test_that("MapTestsToCoveredLines returns per-test covered lines (#265)", {
  dfFileTests <- tibble::tibble(
    Test = c("test A", "test B"),
    File = c("tests/testthat/test-foo.R", "tests/testthat/test-foo.R"),
    LineStart = c(1L, 10L),
    LineEnd = c(5L, 15L),
    Issues = list(integer(), 1L),
    TaggedNoIssue = c(FALSE, FALSE)
  )
  local_mocked_bindings(
    GetPkgRoot = function(strPkgRoot, envCall = rlang::caller_env()) "/pkg",
    ReadTestFileContents = function(dfFileTests) {
      list(
        "tests/testthat/test-foo.R" = c(
          'test_that("test A", {',
          "  1",
          "})",
          "",
          "",
          "",
          "",
          "",
          "",
          'test_that("test B", {',
          "  2",
          "}",
          "",
          "",
          ""
        )
      )
    },
    CoverSingleTest = function(
      envPkg,
      strTempFile,
      strPkgRoot,
      strTestFile,
      strTempSnapDir,
      strAbsTestDir
    ) {
      chrCode <- readLines(strTempFile)
      if (any(grepl("test A", chrCode))) {
        tibble::tibble(
          SourceFile = c("R/foo.R", "R/foo.R"),
          Line = c(10L, 11L)
        )
      } else {
        tibble::tibble(
          SourceFile = c("R/foo.R", "R/bar.R"),
          Line = c(10L, 5L)
        )
      }
    }
  )
  mock_env <- new.env()
  dfResult <- MapTestsToCoveredLines(mock_env, dfFileTests)
  expect_s3_class(dfResult, "tbl_df")
  expect_named(
    dfResult,
    c("Test", "File", "LineStart", "LineEnd", "Issues", "SourceFile", "Line")
  )
  dfTestA <- dfResult[dfResult$Test == "test A", ]
  expect_identical(dfTestA$SourceFile, c("R/foo.R", "R/foo.R"))
  expect_identical(dfTestA$Line, c(10L, 11L))
  dfTestB <- dfResult[dfResult$Test == "test B", ]
  expect_identical(dfTestB$SourceFile, c("R/foo.R", "R/bar.R"))
  expect_identical(dfTestB$Line, c(10L, 5L))
})

test_that("MapTestsToCoveredLines skips noissue tests (#265)", {
  dfFileTests <- tibble::tibble(
    Test = "skipped test",
    File = "tests/testthat/test-foo.R",
    LineStart = 1L,
    LineEnd = 5L,
    Issues = list(integer()),
    TaggedNoIssue = TRUE
  )
  mock_env <- new.env()
  dfResult <- MapTestsToCoveredLines(mock_env, dfFileTests)
  expect_identical(nrow(dfResult), 0L)
})

test_that("MapTestsToCoveredLines handles empty dfFileTests (#265)", {
  dfFileTests <- tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    TaggedNoIssue = logical()
  )
  mock_env <- new.env()
  dfResult <- MapTestsToCoveredLines(mock_env, dfFileTests)
  expect_identical(nrow(dfResult), 0L)
  expect_named(
    dfResult,
    c("Test", "File", "LineStart", "LineEnd", "Issues", "SourceFile", "Line")
  )
})

test_that("MapTestsToCoveredLines handles test with no coverage (#265)", {
  dfFileTests <- tibble::tibble(
    Test = "empty test",
    File = "tests/testthat/test-foo.R",
    LineStart = 1L,
    LineEnd = 3L,
    Issues = list(integer()),
    TaggedNoIssue = FALSE
  )
  local_mocked_bindings(
    GetPkgRoot = function(strPkgRoot, envCall = rlang::caller_env()) "/pkg",
    ReadTestFileContents = function(dfFileTests) {
      list(
        "tests/testthat/test-foo.R" = c(
          'test_that("empty test", {',
          "  1",
          "})"
        )
      )
    },
    CoverSingleTest = function(
      envPkg,
      strTempFile,
      strPkgRoot,
      strTestFile,
      strTempSnapDir,
      strAbsTestDir
    ) {
      NULL
    }
  )
  mock_env <- new.env()
  dfResult <- MapTestsToCoveredLines(mock_env, dfFileTests)
  expect_identical(nrow(dfResult), 0L)
})
