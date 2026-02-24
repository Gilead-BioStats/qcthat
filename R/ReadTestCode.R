#' Read test code from a file
#'
#' @inheritParams shared-params
#' @inherit SubsetFileLines return
#' @keywords internal
ReadTestCode <- function(
  strFile,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
) {
  ReadFileLines(
    strFile,
    intLineStart = intLineStart,
    intLineEnd = intLineEnd,
    envCall = envCall
  )
}

#' Read lines from a file
#'
#' @inheritParams shared-params
#' @inherit SubsetFileLines return
#' @keywords internal
ReadFileLines <- function(
  strFile,
  strDirPath,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
) {
  ReadExistingFileLines(
    strFile,
    intLineStart,
    intLineEnd,
    envCall = envCall
  )
}

#' Read lines from an existing file
#'
#' @inheritParams shared-params
#' @inherit SubsetFileLines return
#' @keywords internal
ReadExistingFileLines <- function(
  strFilePath,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
) {
  CheckFileLineOrder(intLineStart, intLineEnd, envCall = envCall)
  SubsetFileLines(
    strFilePath,
    intLineStart,
    intLineEnd,
    envCall = envCall
  )
}

#' Check that line numbers are in valid order
#'
#' @inheritParams shared-params
#' @returns Invisibly returns `NULL`. Called for its side effect of validating
#'   line order.
#' @keywords internal
CheckFileLineOrder <- function(
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
) {
  if (intLineEnd < intLineStart) {
    qcthatAbort(
      c(
        "{.arg intLineEnd} must be larger than {.arg intLineStart}.",
        x = "{.arg intLineEnd} is {intLineEnd}, but {.arg intLineStart} is {intLineStart}."
      ),
      strErrorSubclass = "invalid_file_lines",
      envCall = envCall
    )
  }
}

#' Subset lines from a file
#'
#' @inheritParams shared-params
#' @returns A `character` vector containing a subset of lines from the file.
#' @keywords internal
SubsetFileLines <- function(
  strFilePath,
  intLineStart,
  intLineEnd,
  envCall = rlang::caller_env()
) {
  chrFileLines <- readLines(strFilePath, n = intLineEnd, warn = FALSE)
  intTotalLines <- length(chrFileLines)
  if (intLineEnd > intTotalLines) {
    strFile <- fs::path_file(strFilePath)
    qcthatAbort(
      c(
        "Lines must be within the length of {.arg strFile}.",
        "x" = "The file at {.file {strFilePath}} only contains {intTotalLines} lines, but lines {intLineStart}-{intLineEnd} were requested."
      ),
      strErrorSubclass = "invalid_file_lines",
      envCall = envCall
    )
  }
  return(chrFileLines[intLineStart:intLineEnd])
}
