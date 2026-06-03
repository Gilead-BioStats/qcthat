#' Does a user accept the feature?
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Create a GitHub sub-issue assigned to a human reviewer to track user
#' acceptance that the work described in a parent issue is complete. Use this
#' inside a [testthat::test_that()] block to extend test coverage to changes
#' that require human judgment, such as aesthetic or layout changes to a report.
#'
#' @details
#' When called outside of CRAN, inside a git repository, and with an internet
#' connection, `ExpectUserAccepts()` performs the following steps:
#'
#' 1. Looks for an existing child issue of `intIssue` labeled `"qcthat-uat"`
#'    whose title matches `strDescription`.
#' 2. If no such issue exists, creates one as a sub-issue with the title
#'    `"qcthat Acceptance for #N: {strDescription}"`, a body containing
#'    `chrInstructions` and checkbox items from `chrChecks`, and the
#'    `"qcthat-uat"` label.
#' 3. Assigns the issue to `chrAssignees` (re-opening it if it was closed and a
#'    new assignee is added).
#' 4. Checks the issue state:
#'    - **Closed**: calls [testthat::pass()].
#'    - **Open**: calls [testthat::fail()] only when `lglReportFailure` is
#'      `TRUE` (controlled by the `qcthat_UAT` environment variable via
#'      [IsCheckingUAT()]).
#' 5. Logs the result for use in UAT reports (see [CommentUAT()]).
#'
#' When any guard condition is not met (on CRAN, not a git repo, or offline),
#' the function silently returns `strDescription` without side effects.
#'
#' @inheritParams shared-params
#'
#' @returns The input `strDescription`, invisibly.
#'
#' @family UAT functions
#' @seealso
#' * `vignette("expect_user_accepts")` for a full walk-through of the UAT system.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' test_that("report uses updated brand colors (#42)", {
#'   ExpectUserAccepts(
#'     strDescription = "Report header uses updated brand colors",
#'     intIssue = 42L,
#'     chrChecks = c(
#'       "Header background is #59488f",
#'       "Logo is centered and not clipped"
#'     ),
#'     chrAssignees = "design-reviewer"
#'   )
#' })
#' }
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
#' @family UAT functions
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
