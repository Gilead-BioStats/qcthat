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
    dplyr::rowwise() |>
    dplyr::group_split() |>
    purrr::map(fnAsDF)
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
