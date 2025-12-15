#' Create a user-acceptance sub-issue for an issue
#'
#' @inheritParams shared-params
#' @returns A data frame representing the created user-acceptance issue.
#' @keywords internal
CreateUAIssue <- function(
  intIssue,
  chrChecks,
  chrInstructions = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strTitle <- TitleUAIssue(chrChecks)
  strBody <- paste(
    stringr::str_flatten(
      c(
        "Review the following checks and close this issue to indicate your acceptance.",
        chrInstructions
      ),
      collapse = "\n\n"
    ),
    paste("- [ ]", chrChecks, collapse = "\n"),
    sep = "\n\n"
  )
  tryCatch(
    {
      CreateChildIssue(
        intIssue,
        strTitle,
        strBody,
        chrLabels = "qcthat-uat",
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    },
    error = function(e) NULL
  )
}

#' Create a child issue linked to a parent issue
#'
#' @param ... Additional parameters passed to [CreateRepoIssueRaw()].
#' @inheritParams shared-params
#'
#' @returns A tibble with one row representing the created child issue.
#' @keywords internal
CreateChildIssue <- function(
  intParentIssue,
  strTitle,
  strBody,
  ...,
  chrLabels = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lChildIssue <- CreateRepoIssueRaw(
    strTitle = strTitle,
    strBody = strBody,
    chrLabels = chrLabels,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    ...
  )
  lChildIssue$parent_issue_url <- ConnectChildIssueByID(
    strChildIssueID = lChildIssue$id,
    intParentIssue = intParentIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  CompileIssuesDF(list(unclass(lChildIssue)))
}

#' Create an issue in a repository
#'
#' @param ... Additional parameters passed to [CallGHAPI()].
#' @inheritParams shared-params
#'
#' @returns A list representing the issue, as returned by GitHub.
#' @keywords internal
CreateRepoIssueRaw <- function(
  strTitle,
  strBody,
  ...,
  chrLabels = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lIssue <- CallGHAPI(
    "POST /repos/{owner}/{repo}/issues",
    title = strTitle,
    body = strBody,
    labels = as.list(chrLabels),
    ...,
    numLimit = NULL,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  # Clear cache so future calls see the new issue.
  if (length(lIssue)) {
    ClearGHCache()
  }
  return(lIssue)
}

#' Clear the cache used by gh
#'
#' @returns `0` for success, `1` for failure, invisibly (as returned by
#'   [unlink()]).
#' @keywords internal
ClearGHCache <- function() {
  unlink(dir(tools::R_user_dir("gh", "cache"), full.names = TRUE))
}

#' Connect an issue to a parent issue
#'
#' @inheritParams shared-params
#'
#' @returns The URL of the parent issue.
#' @keywords internal
ConnectChildIssueByID <- function(
  strChildIssueID,
  intParentIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "POST /repos/{owner}/{repo}/issues/{issue_number}/sub_issues",
    issue_number = intParentIssue,
    sub_issue_id = strChildIssueID,
    replace_parent = TRUE,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  ClearGHCache()
  # Return this URL because it's the new piece of information for the child
  # issue.
  glue::glue(
    "https://api.github.com/repos/{strOwner}/{strRepo}/issues/{intParentIssue}"
  )
}
