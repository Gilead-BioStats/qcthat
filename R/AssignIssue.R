#' Assign a GitHub issue to one or more users
#'
#' Update the assignee list for a GitHub issue. If any members of `chrAssignees`
#' are not already assigned to the issue, they will be added as assignees, and
#' the issue will be opened if `lglOpenOnAssign` is `TRUE`.
#'
#' @param dfIssue (`data.frame`, `numeric`, `gh_response`, or other) The issue
#'   to assign, as returned by [FetchIssueDetails()], or something that can be
#'   coerced to such a `data.frame`.
#' @param chrAssignees (`character`) GitHub usernames to whom the issue should
#'   be assigned (in addition to any current assignees). Elements will be split
#'   on commas, so a single string can be read from an environment variable and
#'   passed here.
#' @param lglOpenOnAssign (`length-1 logical`) Whether to open the issue if it is
#'   currently closed and at least one assignee is new.
#' @inheritParams shared-params
#'
#' @inherit FetchRepoIssues return
#' @export
AssignIssue <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  UseMethod("AssignIssue", dfIssue)
}

#' @export
AssignIssue.data.frame <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (NROW(dfIssue)) {
    dfIssue <- AssignIssueImpl(
      dfIssue = dfIssue,
      chrAssignees = chrAssignees,
      lglOpenOnAssign = lglOpenOnAssign,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
  return(dfIssue)
}

#' @export
AssignIssue.numeric <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfIssue <- FetchIssueDetails(
    dfIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  AssignIssue.data.frame(
    dfIssue,
    chrAssignees = chrAssignees,
    lglOpenOnAssign = lglOpenOnAssign,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' @export
AssignIssue.gh_response <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  # nocov start
  AssignIssue.data.frame(
    CompileIssuesDF(dfIssue),
    chrAssignees = chrAssignees,
    lglOpenOnAssign = lglOpenOnAssign,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  # nocov end
}

#' @export
AssignIssue.default <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  # nocov start
  AssignIssue.data.frame(
    AsIssuesDF(tibble::as_tibble(dfIssue)),
    chrAssignees = chrAssignees,
    lglOpenOnAssign = lglOpenOnAssign,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  # nocov end
}

#' Update a GitHub issue (implementation)
#'
#' @inheritParams shared-params
#' @inherit FetchRepoIssues return
#' @keywords internal
AssignIssueImpl <- function(
  dfIssue,
  chrAssignees = character(),
  lglOpenOnAssign = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  if (nrow(dfIssue) > 1) {
    qcthatAbort(
      c(
        "{.arg dfIssue} must contain only one issue.",
        x = "{.arg dfIssue} contains {nrow(dfIssue)} issues."
      ),
      strErrorSubclass = "multiple_issue_assignment",
      envCall = envCall
    )
  }
  chrAssignees <- SplitFlattenCommas(chrAssignees)
  existingAssignees <- CompletelyFlatten(dfIssue$Assignees)
  if (any(!(chrAssignees %in% existingAssignees))) {
    dfIssue <- UpdateIssue(
      intIssue = dfIssue$Issue,
      chrAssignees = sort(unique(c(existingAssignees, chrAssignees))),
      strState = if (lglOpenOnAssign) "open" else NULL,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
  return(dfIssue)
}
