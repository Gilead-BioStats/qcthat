#' Comment on a GitHub Issue
#'
#' Create or update a comment on a GitHub issue with a standardized format.
#'
#' @inheritParams shared-params
#'
#' @returns The comment object as returned by [gh::gh()], invisibly.
#' @export
#'
#' @examplesIf interactive()
#' # This only works if you have an issue #1 in your repository.
#' CommentIssue(
#'   intIssue = 1,
#'   strTitle = "QC Report",
#'   strBody = "All checks passed successfully."
#' )
CommentIssue <- function(
  intIssue,
  strTitle,
  strBody,
  strCommentID = rlang::hash(strTitle),
  lglUpdate = TRUE,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strBodyCompiled <- glue::glue(
    "## {strTitle}\n\n{strBody}\n\n<!-- qcthat-comment-id: {strCommentID} -->"
  )
  if (lglUpdate) {
    return(
      UpdateIssueComment(
        intIssue = intIssue,
        strBodyCompiled = strBodyCompiled,
        strCommentID = strCommentID,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    )
  }
  CommentIssueRaw(
    intIssue = intIssue,
    strBodyCompiled = strBodyCompiled,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Update or create a comment on a GitHub issue
#'
#' @inheritParams shared-params
#' @returns The comment object as returned by [gh::gh()], invisibly.
#' @keywords internal
UpdateIssueComment <- function(
  intIssue,
  strBodyCompiled,
  strCommentID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dblCommentGHID <- FetchIssueCommentGHID(
    intIssue = intIssue,
    strCommentID = strCommentID,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (length(dblCommentGHID)) {
    return(
      UpdateCommentRaw(
        dblCommentGHID = dblCommentGHID,
        strBodyCompiled = strBodyCompiled,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    )
  }
  CommentIssueRaw(
    intIssue = intIssue,
    strBodyCompiled = strBodyCompiled,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Fetch the GitHub ID of an issue comment by its qcthat comment ID
#'
#' @inheritParams shared-params
#' @returns The GitHub ID of the comment.
#' @keywords internal
FetchIssueCommentGHID <- function(
  intIssue,
  strCommentID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchIssueComments(
    intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      .data$qcthatCommentID == strCommentID
    ) |>
    dplyr::pull("CommentGHID")
}

#' Update a GitHub comment
#'
#' @inheritParams shared-params
#' @returns The comment object as returned by [gh::gh()], invisibly.
#' @keywords internal
UpdateCommentRaw <- function(
  dblCommentGHID,
  strBodyCompiled,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  invisible(
    CallGHAPI(
      "PATCH /repos/{owner}/{repo}/issues/comments/{comment_id}",
      strOwner = strOwner,
      strRepo = strRepo,
      comment_id = dblCommentGHID,
      body = strBodyCompiled,
      strGHToken = strGHToken
    )
  )
}

#' Comment on a GitHub issue
#'
#' @inheritParams shared-params
#' @returns The comment object as returned by [gh::gh()], invisibly.
#' @keywords internal
CommentIssueRaw <- function(
  intIssue,
  strBodyCompiled,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  invisible(
    CallGHAPI(
      "POST /repos/{owner}/{repo}/issues/{issue_number}/comments",
      strOwner = strOwner,
      strRepo = strRepo,
      issue_number = intIssue,
      body = strBodyCompiled,
      strGHToken = strGHToken
    )
  )
}
