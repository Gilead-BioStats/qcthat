#' Check the status of a UAT issue
#'
#' @inheritParams shared-params
#' @returns The value of `envQcthat$UATIssues`, invisibly (called for side
#'   effects).
#' @keywords internal
CheckUAIssue <- function(
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
  lUAIssue <- FetchUAIssue(
    strDescription = strDescription,
    intIssue = intIssue,
    chrInstructions = chrInstructions,
    chrChecks = chrChecks,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (
    length(lUAIssue$Issue) &&
      length(chrAssignees) &&
      !identical(chrAssignees, "")
  ) {
    lUAIssue <- AssignIssue(
      lUAIssue,
      chrAssignees = chrAssignees,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    ) |>
      as.list()
  }
  strState <- lUAIssue[["State"]] %||% "NULL"
  switch(
    strState,
    closed = {
      strDisposition <- "accepted"
      testthat::pass()
    },
    open = {
      strDisposition <- "pending"
      if (isTRUE(lglReportFailure)) {
        testthat::fail(c(
          "User must accept the checks and close the issue.",
          cli::format_inline(
            "User-acceptance issue: {.url {lUAIssue[['Url']]}}"
          )
        ))
      }
    },
    failed_to_create = {
      strDisposition <- "failed_to_create"
      if (isTRUE(lglReportFailure)) {
        testthat::fail(c(
          "Failed to create user-acceptance issue.",
          "This may be due to GitHub being down or an issue with authentication or permissions."
        ))
      }
    },
    {
      strDisposition <- "error"
      if (isTRUE(lglReportFailure)) {
        testthat::fail(c(
          "Unexpected state for user-acceptance issue: {.str {lUAIssue[['State']]}}."
        ))
      }
    }
  )
  LogUAT(
    intParentIssue = intIssue,
    intUATIssue = lUAIssue[["Issue"]],
    strDescription = strDescription,
    strDisposition = strDisposition,
    strOwner = strOwner,
    strRepo = strRepo
  )
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
