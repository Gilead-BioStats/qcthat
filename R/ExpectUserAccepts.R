#' Does a user accept the feature?
#'
#' Create and track a sub-issue to track user acceptance that an issue is
#' complete.
#'
#' @inheritParams shared-params
#' @returns The input `chrChecks`, invisibly.
#' @export
ExpectUserAccepts <- function(
  strDescription,
  intIssue,
  chrInstructions = character(),
  chrChecks = character(),
  strFailureMode = c("ignore", "fail"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!OnCran() && UsesGit()) {
    strFailureMode <- rlang::arg_match(strFailureMode)
    lUAIssue <- FetchUAIssue(
      strDescription = strDescription,
      intIssue = intIssue,
      chrInstructions = chrInstructions,
      chrChecks = chrChecks,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    if (identical(lUAIssue[["State"]], "closed")) {
      testthat::pass()
    } else if (identical(strFailureMode, "fail")) {
      testthat::fail(c(
        "User must accept the checks and close the issue.",
        cli::format_inline("User-acceptance issue: {.url {lUAIssue[['Url']]}}")
      ))
    }
  }
  return(invisible(strDescription))
}

#' Check whether this is being tested on CRAN
#'
#' @returns Logical indicating whether this is running on CRAN (according to
#'   testthat).
#' @keywords internal
OnCran <- function() {
  # Inspired by unexported testthat helper.
  strNotCRAN <- Sys.getenv("NOT_CRAN")
  !identical(strNotCRAN, "") && !isTRUE(as.logical(strNotCRAN))
}
