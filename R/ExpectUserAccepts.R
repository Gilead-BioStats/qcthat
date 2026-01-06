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
  if (!OnCran() && UsesGit() && IsOnline()) {
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
      strDisposition <- "accepted"
      testthat::pass()
    } else {
      strDisposition <- "pending"
      if (identical(strFailureMode, "fail")) {
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
  cli::cli_inform("Logging UAT result: {intUATIssue}")
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
