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
