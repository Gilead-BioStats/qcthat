#' Null-default operator
#'
#' @param x Object to test.
#' @param y Object to return if `x` is `NULL`.
#' @returns `x` or `y`.
#' @keywords internal
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
