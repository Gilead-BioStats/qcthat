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
  lglReportFailure = IsCheckingUAT(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!OnCran() && UsesGit() && IsOnline()) {
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
      strDisposition <- "accepted"
      testthat::pass()
    } else {
      strDisposition <- "pending"
      if (isTRUE(lglReportFailure)) {
        testthat::fail(c(
          "User must accept the checks and close the issue.",
          cli::format_inline(
            "User-acceptance issue: {.url {lUAIssue[['Url']]}}"
          )
        ))
      }
    }
    LogUAT(
      intParentIssue = intIssue,
      intUATIssue = lUAIssue[["Issue"]],
      strDescription = strDescription,
      strDisposition = strDisposition,
      strOwner = strOwner,
      strRepo = strRepo
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
#'
#' @returns `TRUE` if the specified environment variable is set to `"TRUE"`
#'   (case-insensitive), `FALSE` otherwise.
#' @export
#'
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

#' Log ExpectUserAccepts results
#'
#' @inheritParams shared-params
#' @returns The value of `envQcthat$UATIssues`, invisibly
#' @keywords internal
LogUAT <- function(
  intParentIssue,
  intUATIssue,
  strDescription,
  strDisposition,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  dttmTimestamp = Sys.time()
) {
  dfUpdatedIssue <- tibble::tibble(
    ParentIssue = intParentIssue,
    UATIssue = intUATIssue,
    Description = strDescription,
    Disposition = strDisposition,
    Owner = strOwner,
    Repo = strRepo,
    Timestamp = dttmTimestamp
  )

  envQcthat$UATIssues <- envQcthat$UATIssues |>
    dplyr::anti_join(
      dfUpdatedIssue,
      # Don't use UATIssue in the join, because it's NULL in some situations.
      by = c("ParentIssue", "Description", "Owner", "Repo")
    ) |>
    dplyr::bind_rows(dfUpdatedIssue)
}
