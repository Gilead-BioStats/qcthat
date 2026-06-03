#' Save an object as JSON
#'
#' Save an object as formatted JSON. This is a generic function with a method
#' for `qcthat_IssueTestMatrix` objects that preserves attributes and column
#' order.
#'
#' @param x (`any`) An R object to save as JSON.
#' @inheritParams shared-params
#'
#' @returns The input object `x`, invisibly.
#' @export
SaveAsJSON <- function(x, strJSONPath) {
  UseMethod("SaveAsJSON")
}

#' @export
#' @rdname SaveAsJSON
SaveAsJSON.default <- function(x, strJSONPath) {
  jsonlite::write_json(x, strJSONPath, pretty = TRUE)
  invisible(x)
}

#' @export
#' @rdname SaveAsJSON
SaveAsJSON.qcthat_IssueTestMatrix <- function(x, strJSONPath) {
  lITM <- list(
    IssueTestMatrix = tibble::as_tibble(x),
    IgnoredIssues = attr(x, "IgnoredIssues"),
    ColumnOrder = colnames(x)
  )
  strITM <- jsonlite::toJSON(lITM, pretty = TRUE)
  writeLines(strITM, strJSONPath)
  invisible(x)
}

#' Read a JSON file as an IssueTestMatrix
#'
#' Read a JSON file that was saved with `SaveAsJSON.qcthat_IssueTestMatrix()`
#' and return it as a `qcthat_IssueTestMatrix` object.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object.
#' @export
ReadJSONAsIssueTestMatrix <- function(strJSONPath) {
  strITM <- readLines(strJSONPath)
  lITM <- jsonlite::fromJSON(strITM)
  dfITM <- AsIssueTestMatrix(tibble::as_tibble(lITM$IssueTestMatrix))
  attr(dfITM, "IgnoredIssues") <- lITM$IgnoredIssues
  dfITM <- dfITM[, lITM$ColumnOrder]
  if ("Labels" %in% colnames(dfITM)) {
    dfITM[["Labels"]] <- purrr::map(
      dfITM[["Labels"]],
      NullIfEmpty
    )
  }
  if ("CreatedAt" %in% colnames(dfITM)) {
    dfITM[["CreatedAt"]] <- as.POSIXct(dfITM[["CreatedAt"]], tz = "UTC")
  }
  if ("ClosedAt" %in% colnames(dfITM)) {
    dfITM[["ClosedAt"]] <- as.POSIXct(dfITM[["ClosedAt"]], tz = "UTC")
  }
  if ("Disposition" %in% colnames(dfITM)) {
    dfITM[["Disposition"]] <- factor(
      dfITM[["Disposition"]],
      levels = c("fail", "warn", "skip", "pass")
    )
  }
  return(dfITM)
}
