#' Generate a classed qcthat error
#'
#' @param cndParent (`condition` or `NULL`) Parent condition, if any.
#' @param ... Additional parameters to pass to [cli::cli_abort()].
#' @inheritParams shared-params
#' @keywords internal
qcthatAbort <- function(
  strErrorMessage,
  strErrorSubclass,
  envCall = rlang::caller_env(),
  envErrorMessage = rlang::caller_env(),
  cndParent = NULL,
  ...
) {
  cli::cli_abort(
    strErrorMessage,
    class = CompileConditionClasses(strErrorSubclass),
    call = envCall,
    .envir = envErrorMessage,
    parent = cndParent,
    ...
  )
}

#' Paste together standardized pieces of a condition class
#'
#' @inheritParams shared-params
#' @returns A character vector of condition classes.
#' @keywords internal
CompileConditionClasses <- function(
  strConditionSubclass,
  strConditionClass = c("error", "warning", "message")
) {
  strConditionClass <- rlang::arg_match(strConditionClass)
  return(paste(
    "qcthat",
    c(
      glue::glue("{strConditionClass}-{strConditionSubclass}"),
      strConditionClass,
      "condition"
    ),
    sep = "-"
  ))
}
