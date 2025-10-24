#' Assign a class and expected structure to a data frame
#'
#' @param df (`data.frame`) Data frame to assign the class to.
#' @param dfShape (`0-row data.frame`) Data frame with the expected structure.
#' @param chrClass (`character`) Class name(s) to assign to the data frame.
#' @returns A data frame with the expected structure and class.
#' @keywords internal
AsExpectedDF <- function(df, dfShape, chrClass) {
  if (!length(df) || !NROW(df)) {
    df <- dfShape
  }
  structure(df, class = unique(c(chrClass, class(df))))
}
