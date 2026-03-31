#' Update a GitHub issue
#'
#' Update one or more fields in a GitHub issue. `NULL` values are ignored, while
#' empty values (such as `character()`) often result in clearing the field. See
#' the [GitHub API
#' documentation](https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#update-an-issue)
#' for more details.
#'
#' @param intIssue (`length-1 integer`) The issue to update.
#' @param ... Additional arguments to pass to [CallGHAPI()]. Any `NULL` values
#'   are discarded.
#' @param strState (`length-1 integer`) The state to set. Must be one of
#'   `"open"`, `"closed"`, or `NULL` (to ignore this field).
#' @param strMilestone (`length-1 character`) The milestone to set. Must be the
#'   title of an existing milestone, `NULL` (to ignore this field), or
#'   `character()` to remove the milestone.
#' @param chrAssignees (`character`) The assignees to set. Must be the logins of
#'   existing users, `NULL` (to ignore this field), or `character()` to remove
#'   all assignees.
#' @param strType (`length-1 character`) The type of issue to set. Must be the
#'   name of an issue type available to this repo, or `NULL` (to ignore this
#'   field).
#' @inheritParams shared-params
#'
#' @inherit FetchRepoIssues return
#' @export
UpdateIssue <- function(
  intIssue,
  ...,
  strTitle = NULL,
  strBody = NULL,
  strState = NULL,
  strStateReason = NULL,
  strMilestone = NULL,
  chrLabels = NULL,
  chrAssignees = NULL,
  strType = NULL,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  UpdateIssueRaw(
    intIssue = intIssue,
    strTitle = strTitle,
    strBody = strBody,
    strState = strState,
    strStateReason = strStateReason,
    strMilestone = strMilestone,
    chrLabels = chrLabels,
    chrAssignees = chrAssignees,
    strType = strType,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    ...
  ) |>
    CompileIssuesDF()
}

#' Update an issue through the GitHub API
#'
#' @inheritParams UpdateIssue
#' @returns A list with a raw issue object as returned by [gh::gh()].
#' @keywords internal
UpdateIssueRaw <- function(
  intIssue,
  ...,
  strTitle = NULL,
  strBody = NULL,
  strState = NULL,
  strStateReason = NULL,
  strMilestone = NULL,
  chrLabels = NULL,
  chrAssignees = NULL,
  strType = NULL,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  args <- list(
    title = strTitle,
    body = strBody,
    state = strState,
    state_reason = strStateReason,
    milestone = strMilestone,
    labels = if (!is.null(chrLabels)) as.list(chrLabels),
    assignees = if (!is.null(chrAssignees)) as.list(chrAssignees),
    type = strType,
    ...
  ) |>
    purrr::discard(is.null)

  lIssue <- rlang::inject(CallGHAPI(
    "PATCH /repos/{owner}/{repo}/issues/{issue_number}",
    issue_number = intIssue,
    !!!args,
    numLimit = NULL,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ))
  # Clear cache so future calls see the new issue.
  if (length(lIssue)) {
    ClearGHCache()
  }
  return(lIssue)
}
