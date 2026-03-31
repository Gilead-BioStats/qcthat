#' Does a user accept the feature?
#'
#' @description
#' `r lifecycle::badge("experimental")`
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
  lglReportFailure = IsCheckingUAT(),
  chrAssignees = Sys.getenv("qcthat_UAT_ASSIGNEES"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!OnCran() && UsesGit() && IsOnline()) {
    CheckUAIssue(
      strDescription = strDescription,
      intIssue = intIssue,
      chrInstructions = chrInstructions,
      chrChecks = chrChecks,
      lglReportFailure = lglReportFailure,
      chrAssignees = chrAssignees,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
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

#' Check whether the user is online
#'
#' @returns `TRUE` if the user is online.
#' @keywords internal
IsOnline <- function() {
  # nocov start
  rlang::check_installed("httr2", "to check online status.")
  httr2::is_online()
  # nocov end
}

#' Detect whether the user is specifically checking UAT issues
#'
#' Checks the value of an environment variable (default: `qcthat_UAT`) to
#' determine if the user is intentionally checking user-acceptance tests.
#'
#' @param strUATEnvVar (`length-1 character`) The name of the environment
#'   variable to check.
#' @returns `TRUE` if the specified environment variable is set to `"TRUE"`
#'   (case-insensitive), `FALSE` otherwise.
#' @export
#' @examples
#' CurrentValue <- Sys.getenv("qcthat_UAT")
#' Sys.setenv(qcthat_UAT = "")
#' IsCheckingUAT()
#' Sys.setenv(qcthat_UAT = "true")
#' IsCheckingUAT()
#' Sys.setenv(qcthat_UAT = CurrentValue)
IsCheckingUAT <- function(strUATEnvVar = "qcthat_UAT") {
  identical(toupper(Sys.getenv(strUATEnvVar)), "TRUE")
}
