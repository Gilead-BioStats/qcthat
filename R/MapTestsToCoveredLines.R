#' Map tests to covered source lines
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with one row per (test, source line) pair:
#'   - `Test`: The `desc` field of the test from [testthat::test_that()].
#'   - `File`: Path to the test file, relative to the package root.
#'   - `LineStart`: Starting line number of the test.
#'   - `LineEnd`: Ending line number of the test.
#'   - `Issues`: List column of integer vectors of already-tagged issue numbers.
#'   - `SourceFile`: Path to the R source file, relative to the package root.
#'   - `Line`: Line number in `SourceFile` exercised by this test.
#' @keywords internal
MapTestsToCoveredLines <- function(
  envPkg,
  dfFileTests = NULL,
  strTestDir = "tests/testthat",
  envCall = rlang::caller_env()
) {
  rlang::check_installed("covr", "to trace source line coverage")
  dfFileTests <- dfFileTests %||%
    ExtractTestsFromFiles(strTestDir = strTestDir)

  dfFileTests <- dplyr::filter(dfFileTests, !.data$TaggedNoIssue) |>
    dplyr::select(-"TaggedNoIssue")

  if (!nrow(dfFileTests)) {
    return(EmptyTestCoveredLinesDF())
  }

  strPkgRoot <- GetPkgRoot(strTestDir, envCall = envCall)
  strAbsTestDir <- file.path(strPkgRoot, strTestDir)
  strSnapDir <- file.path(strTestDir, "_snaps")
  chrFileContents <- ReadTestFileContents(dfFileTests, strTestDir)

  withr::local_envvar(R_TESTS = "", R_BROWSER = "false", R_PDFVIEWER = "false")

  lstTestCode <- ExtractAllTestCode(dfFileTests, chrFileContents)
  chrTempFiles <- WriteAllTempTestFiles(lstTestCode)
  on.exit(unlink(chrTempFiles), add = TRUE)

  chrTempSnapDirs <- purrr::map_chr(
    dfFileTests$File,
    \(strFile) SetupTempSnapDir(strFile, strSnapDir)
  )
  on.exit(unlink(chrTempSnapDirs, recursive = TRUE), add = TRUE)

  purrr::pmap(
    list(
      Test = dfFileTests$Test,
      File = dfFileTests$File,
      LineStart = dfFileTests$LineStart,
      LineEnd = dfFileTests$LineEnd,
      Issues = dfFileTests$Issues,
      TempFile = chrTempFiles,
      TempSnapDir = chrTempSnapDirs
    ),
    \(Test, File, LineStart, LineEnd, Issues, TempFile, TempSnapDir) {
      dfCovered <- CoverSingleTest(
        envPkg,
        strTempFile = TempFile,
        strPkgRoot = strPkgRoot,
        strTestFile = File,
        strTempSnapDir = TempSnapDir,
        strAbsTestDir = strAbsTestDir
      )
      if (is.null(dfCovered) || !nrow(dfCovered)) {
        return(NULL)
      }
      tibble::tibble(
        Test = Test,
        File = File,
        LineStart = LineStart,
        LineEnd = LineEnd,
        Issues = list(Issues),
        SourceFile = dfCovered$SourceFile,
        Line = dfCovered$Line
      )
    }
  ) |>
    purrr::list_rbind() %||%
    EmptyTestCoveredLinesDF()
}

#' Read test file contents once per unique file
#'
#' @inheritParams shared-params
#' @returns A named list of character vectors, keyed by file path.
#' @keywords internal
ReadTestFileContents <- function(dfFileTests, strTestDir) {
  chrUniquePaths <- unique(dfFileTests$File)
  purrr::set_names(
    purrr::map(chrUniquePaths, \(strPath) readLines(strPath, warn = FALSE)),
    chrUniquePaths
  )
}

#' Extract test code with file preamble
#'
#' @param chrFileLines (`character`) All lines of the test file.
#' @param intLineStart (`length-1 integer`) Start line of the test block.
#' @param intLineEnd (`length-1 integer`) End line of the test block.
#' @param intFirstTestLine (`length-1 integer`) Line number of the first
#'   `test_that()` call in the file.
#' @returns A character vector of the preamble (if any) followed by the test
#'   code.
#' @keywords internal
ExtractTestWithPreamble <- function(
  chrFileLines,
  intLineStart,
  intLineEnd,
  intFirstTestLine
) {
  chrTestCode <- chrFileLines[intLineStart:intLineEnd]
  if (intFirstTestLine > 1L && intLineStart >= intFirstTestLine) {
    chrPreamble <- chrFileLines[1:(intFirstTestLine - 1L)]
    c(chrPreamble, chrTestCode)
  } else {
    chrTestCode
  }
}

#' Extract test code blocks for all tests
#'
#' @inheritParams shared-params
#' @param chrFileContents (`list`) Named list of file contents from
#'   [ReadTestFileContents()].
#' @returns A list of character vectors, one per test.
#' @keywords internal
ExtractAllTestCode <- function(dfFileTests, chrFileContents) {
  dfFirstLines <- dplyr::summarise(
    dfFileTests,
    FirstTestLine = min(.data$LineStart),
    .by = "File"
  )
  dfWithFirst <- dplyr::left_join(dfFileTests, dfFirstLines, by = "File")
  purrr::pmap(dfWithFirst, \(File, LineStart, LineEnd, FirstTestLine, ...) {
    chrFileLines <- chrFileContents[[File]]
    ExtractTestWithPreamble(chrFileLines, LineStart, LineEnd, FirstTestLine)
  })
}

#' Write all temporary test files at once
#'
#' @param lstTestCode (`list`) List of character vectors, one per test.
#' @returns A character vector of temp file paths.
#' @keywords internal
WriteAllTempTestFiles <- function(lstTestCode) {
  chrTempFiles <- replicate(length(lstTestCode), tempfile(fileext = ".R"))
  purrr::walk2(lstTestCode, chrTempFiles, writeLines)
  chrTempFiles
}

#' Run coverage for a single test block
#'
#' @param envPkg (`environment`) Loaded package environment.
#' @param strTempFile (`length-1 character`) Path to the already-written
#'   temporary test file.
#' @param strPkgRoot (`length-1 character`) Path to the package root.
#' @param strTestFile (`length-1 character`) Original test file path (used for
#'   snapshot directory resolution).
#' @param strTempSnapDir (`length-1 character`) Path to the already-prepared
#'   temp snapshot directory.
#' @param strAbsTestDir (`length-1 character`) Absolute path to the test
#'   directory, passed to [testthat::local_test_directory()].
#' @returns A [tibble::tibble()] with `SourceFile` (package-relative) and `Line`
#'   columns for covered lines, or `NULL` on failure.
#' @keywords internal
CoverSingleTest <- function(
  envPkg,
  strTempFile,
  strPkgRoot,
  strTestFile,
  strTempSnapDir,
  strAbsTestDir
) {
  testthat::local_test_directory(strAbsTestDir)

  snap_reporter <- testthat::local_snapshotter(snap_dir = strTempSnapDir)
  snap_reporter$start_file(basename(strTestFile))
  reporter <- testthat::MultiReporter$new(
    reporters = list(
      testthat::StopReporter$new(praise = FALSE),
      snap_reporter
    )
  )

  testthat::with_reporter(reporter, {
    objCoverage <- tryCatch(
      CoverSingleTestRaw(envPkg, strTempFile),
      error = function(e) NULL
    )
    reporter$end_file()
  })
  if (is.null(objCoverage)) {
    return(NULL)
  }

  dfTally <- TallyCoverage(objCoverage)
  dfTally <- dfTally[dfTally$value > 0, , drop = FALSE]
  if (!nrow(dfTally)) {
    return(NULL)
  }
  NormalizeTallyPaths(dfTally, strPkgRoot)
}

#' Create a temp snapshot directory with a copy of the relevant snapshot file
#'
#' @param strTestFile (`length-1 character`) Original test file path.
#' @param strSnapDir (`length-1 character`) Path to the real `_snaps` directory.
#' @returns Path to the temp snapshot directory.
#' @keywords internal
SetupTempSnapDir <- function(strTestFile, strSnapDir) {
  strTempSnapDir <- tempfile("snaps_")
  dir.create(strTempSnapDir)
  strSnapName <- fs::path_ext_set(
    stringr::str_remove(
      fs::path_file(strTestFile),
      "^test-"
    ),
    "md"
  )
  strSnapFile <- file.path(strSnapDir, strSnapName)
  if (file.exists(strSnapFile)) {
    file.copy(strSnapFile, file.path(strTempSnapDir, strSnapName))
  }
  strTempSnapDir
}

#' Run covr::environment_coverage (raw wrapper for mocking)
#'
#' @param envPkg (`environment`) Loaded package environment.
#' @param strTempFile (`length-1 character`) Path to a temporary test file.
#' @returns A `coverage` object.
#' @keywords internal
CoverSingleTestRaw <- function(envPkg, strTempFile) {
  # nocov start
  tryCatch(
    covr::environment_coverage(envPkg, strTempFile),
    error = function(e) NULL
  )
  # nocov end
}

#' Tally coverage (wrapper for mocking)
#'
#' @param objCoverage A `coverage` object.
#' @returns A data frame as returned by [covr::tally_coverage()].
#' @keywords internal
TallyCoverage <- function(objCoverage) {
  # nocov start
  covr::tally_coverage(objCoverage)
  # nocov end
}

#' Normalize tally paths to package-relative
#'
#' @param dfTally (`data.frame`) A tally data frame with a `filename` column.
#' @param strPkgRoot (`length-1 character`) Path to the package root.
#' @returns A [tibble::tibble()] with `SourceFile` (package-relative) and `Line`
#'   columns.
#' @keywords internal
NormalizeTallyPaths <- function(dfTally, strPkgRoot) {
  tibble::tibble(
    SourceFile = as.character(fs::path_rel(dfTally$filename, strPkgRoot)),
    Line = as.integer(dfTally$line)
  )
}

#' Empty test covered lines data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyTestCoveredLinesDF <- function() {
  tibble::tibble(
    Test = character(),
    File = character(),
    LineStart = integer(),
    LineEnd = integer(),
    Issues = vctrs::list_of(.ptype = integer()),
    SourceFile = character(),
    Line = integer()
  )
}
