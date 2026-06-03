#' Assign a class and expected structure to an object
#'
#' @param x Object to assign the class to.
#' @returns An object with the expected structure and class. Note: If `x` has a
#'   length and/or rows, the structure is not validated against `objShape`.
#' @keywords internal
AsExpected <- function(x, objShape, chrClass) {
  if (!length(x) || !NROW(x)) {
    x <- objShape
  }
  structure(x, class = unique(c(chrClass, "qcthat_Object", class(x))))
}

#' Listify a 1-row data frame and assign a class
#'
#' @param x (`data.frame` or `list`) Object to convert to a list.
#' @param lShape (`list`) List with the expected shape.
#' @inheritParams shared-params
#' @returns A list with the expected shape and class.
#' @keywords internal
AsExpectedFlat <- function(x, lShape, chrClass) {
  AsExpected(
    purrr::flatten(as.list(x %||% NULL)),
    objShape = lShape,
    chrClass = chrClass
  )
}

#' Split a data frame by rows and transform
#'
#' @param df (`data.frame`) Data frame to split by rows.
#' @param fnAsDF (`function`) Function to apply to each single-row data frame.
#'
#' @returns A list of objects, each processed via `fnAsDF`.
#' @keywords internal
AsRowDFList <- function(df, fnAsDF) {
  df |>
    split(rownames(df)) |>
    purrr::map(fnAsDF) |>
    unname()
}

#' Convenience function to count non-NA unique values
#'
#' @param x (`vector`) Vector to count unique non-NA values in.
#' @returns An integer representing the number of unique non-NA values in `x`.
#' @keywords internal
CountNonNA <- function(x) {
  sum(!is.na(unique(x)))
}

#' Flatten empty vectors into NULL
#'
#' @param x An object to potentially flatten.
#'
#' @returns `NULL` if `x` has length 0, otherwise `x`.
#' @keywords internal
NullIfEmpty <- function(x) {
  if (!length(x)) {
    return(NULL)
  }
  return(x)
}

#' Add an s to a word based on count
#'
#' @param strSingular (`character`) Singular form of the word.
#' @param intN (`integer`) Count to determine singular vs. plural.
#'
#' @returns A character string with the singular or plural form of the word.
#' @keywords internal
SimplePluralize <- function(strSingular, intN) {
  ifelse(intN == 1, strSingular, paste0(strSingular, "s"))
}

#' Get rid of list structure
#'
#' @param lPuffy (`list`) A potentially nested list with one type of object you
#'   want to keep.
#'
#' @returns A sorted, unnamed vector of unique values from the unlisted list.
#' @keywords internal
CompletelyFlatten <- function(lPuffy) {
  sort(unique(unname(unlist(lPuffy))))
}

#' Detect strings in lists of characters
#'
#' @param lCharacters (`list` of `character`) A list of character vectors.
#' @param strTarget (`length-1 character`) The target string to search for.
#' @returns A logical vector indicating whether `strTarget` is present in each
#'   element of `lCharacters`.
#' @keywords internal
HaveString <- function(lCharacters, strTarget) {
  purrr::map_lgl(
    lCharacters,
    function(chrSet) {
      length(strTarget) && any(strTarget %in% chrSet)
    }
  )
}

`%|0|%` <- function(x, y) {
  if (!length(x)) y else x
}

#' Get the formatted time
#'
#' @param strTimezone (`length-1 character`) Timezone to use for formatting.
#' @returns A length-1 character vector representing the current time in the
#'   given timezone.
#' @keywords internal
PrettyTimestamp <- function(strTimezone = "UTC") {
  format(
    Sys.time(),
    tz = strTimezone,
    usetz = TRUE,
    format = "%Y-%m-%d %H:%M:%S"
  )
}

#' Glue without collisions of curly braces
#'
#' @param ... Values to glue and/or additional arguments passed to
#'   [glue::glue()].
#' @param .sep (`length-1 character`) Separator to use between glued values.
#' @param .open (`length-1 character`) Opening delimiter. Defaults value avoids
#'   collisions.
#' @param .close (`length-1 character`) Closing delimiter. Defaults value avoids
#'   collisions.
#' @param .envir (`environment`) Environment to evaluate expressions in.
#' @returns The glued expression as a length-1 character vector.
#' @keywords internal
GlueEscaped <- function(
  ...,
  .sep = "\n\n",
  .open = "qcthatopen{",
  .close = "}qcthatclose",
  .envir = rlang::caller_env()
) {
  glue::glue(
    ...,
    .sep = .sep,
    .open = .open,
    .close = .close,
    .envir = .envir
  )
}

#' Choose between recode functions based on dplyr version
#'
#' @param x (`vector`) The vector to recode.
#' @param ... Recode pairs in the form of `old ~ new`. See [dplyr::case_match()]
#'   or [dplyr::recode_values()] for details.
#' @param default (`scalar`) The default value to use for unmatched cases. See
#'   [dplyr::case_match()] or [dplyr::recode_values()] for details.
#' @returns A vector with the same size as `x` with values recoded according to
#'   the specified pairs and default.
#' @keywords internal
RecodeValues <- function(x, ..., default = NULL) {
  if (rlang::is_installed("dplyr", version = "1.2.0")) {
    return(rlang::exec(dplyr::recode_values, x, ..., default = default))
  }
  rlang::exec(dplyr::case_match, x, .default = default, ...) # nocov
}

#' Convenience function to glue data and collapse with a separator
#'
#' @param dfData (`data.frame` or `list`) Data frame or list to use as the data
#'   source for [glue::glue_data()].
#' @param ... Expressions to evaluate within the context of `dfData`, passed to
#'   [glue::glue_data()].
#' @param strSep (`length-1 character`) Separator to use between glued values.
#'   Defaults to a newline, which is common for formatting multiple lines of
#'   text in GitHub comments.
#' @returns A string containing the glued and collapsed result.
#' @keywords internal
CollapseGluedData <- function(dfData, ..., strSep = "\n") {
  glue::glue_collapse(
    glue::glue_data(
      dfData,
      ...
    ),
    sep = strSep
  )
}

#' Flatten a character vector of comma-separated values
#'
#' @param chrVector (`character`) The character vector to split. If any element
#'   contains commas, it will be split, and spaces around the commas will be
#'   removed.
#' @returns A character vector with the elements of `chrVector` split by commas
#'   and flattened into a single vector.
#' @keywords internal
SplitFlattenCommas <- function(chrVector) {
  stringr::str_split(chrVector, "\\s*,\\s*") |>
    CompletelyFlatten()
}
