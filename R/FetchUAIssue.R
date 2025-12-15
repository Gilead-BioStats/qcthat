#' Fetch or create a user-acceptance issue
#'
#' @inheritParams shared-params
#'
#' @returns A list representing the user-acceptance issue.
#' @keywords internal
FetchUAIssue <- function(
  intIssue,
  chrChecks,
  chrInstructions = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  # I *think* a hash of the checks is the best way to find these, but we should
  # also figure out some sort of cleanup mechanism to identify unused UAT
  # issues.
  dfMatchingIssue <- FetchIssueUAChildren(
    intIssue = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      .data$Title == TitleUAIssue(chrChecks)
    ) |>
    # If somehow multiple issues match, only use the first one.
    head(1)
  if (!NROW(dfMatchingIssue)) {
    dfMatchingIssue <- CreateUAIssue(
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
#'
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
TitleUAIssue <- function(chrChecks) {
  glue::glue("qcthat Acceptance Issue (ID {rlang::hash(chrChecks)})")
}
