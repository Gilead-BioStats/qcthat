#' Fetch or create a user-acceptance issue
#'
#' @inheritParams shared-params
#' @returns A list representing the user-acceptance issue.
#' @keywords internal
FetchUAIssue <- function(
  strDescription,
  intIssue,
  chrChecks = character(),
  chrInstructions = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfMatchingIssue <- FetchIssueUAChildren(
    intIssue = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      .data$Title == TitleUAIssue(strDescription, intIssue)
    )
  if (NROW(dfMatchingIssue) > 1) {
    # If somehow multiple issues match, use a closed one if available, otherwise
    # use the first one.
    dfMatchingIssue <- dfMatchingIssue |>
      # FALSE is before TRUE, so this will put any "closed" issue at the top.
      dplyr::arrange(.data$State != "closed") |>
      dplyr::slice_head(n = 1)
  }

  if (!NROW(dfMatchingIssue)) {
    # FetchIssueUAChildren fails if GitHub is down or the parent doesn't exist,
    # so this should only happen when the parent exists but doesn't have
    # children.
    dfMatchingIssue <- CreateUAIssue(
      strDescription = strDescription,
      intIssue = intIssue,
      chrChecks = chrChecks,
      chrInstructions = chrInstructions,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
  return(as.list(dfMatchingIssue))
}

#' Fetch all user-acceptance sub-issues for an issue
#'
#' @inheritParams shared-params
#' @returns A data frame of user-acceptance sub-issues.
#' @keywords internal
FetchIssueUAChildren <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchIssueChildren(
    intIssue = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      HaveString(.data$Labels, "qcthat-uat")
    )
}

#' Fetch all children of an issue
#'
#' @inheritParams shared-params
#' @returns A tibble of issue children.
#' @keywords internal
FetchIssueChildren <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lIssueChildrenRaw <- CallGHAPI(
    "GET /repos/{owner}/{repo}/issues/{issue_number}/sub_issues",
    strOwner = strOwner,
    strRepo = strRepo,
    issue_number = intIssue,
    strGHToken = strGHToken
  )
  CompileIssuesDF(lIssueChildrenRaw)
}

#' Generate a title for a UAT issue
#'
#' @inheritParams shared-params
#' @returns A string title for the UAT issue.
#' @keywords internal
TitleUAIssue <- function(strDescription, intIssue) {
  glue::glue("qcthat Acceptance for #{intIssue}: {strDescription}")
}
