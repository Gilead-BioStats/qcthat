#' Fetch comments on an issue
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_Comments` object, which is a [tibble::tibble()] with
#'   columns:
#'   - `Body`: Comment body (the full text of the comment).
#'   - `Url`: URL of the comment on GitHub.
#'   - `CommentGHID`: GitHub ID of the comment.
#'   - `Author`: GitHub username of the comment author.
#'   - `CreatedAt`: `POSIXct` timestamp of when the issue was created.
#'   - `UpdatedAt`: `POSIXct` timestamp of when the issue was last updated.
#'   - `qcthatCommentID`: The `qcthat-comment-id`, which is usually a hash of
#'      the title of the comment (when present).
#' @keywords internal
FetchIssueComments <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lCommentsRaw <- CallGHAPI(
    "GET /repos/{owner}/{repo}/issues/{issue_number}/comments",
    strOwner = strOwner,
    strRepo = strRepo,
    issue_number = intIssue,
    strGHToken = strGHToken
  )
  CompileCommentsDF(lCommentsRaw)
}

#' Compile comments data frame
#'
#' @inheritParams shared-params
#' @inherit FetchIssueComments return
#' @keywords internal
CompileCommentsDF <- function(lCommentsRaw) {
  if (!length(lCommentsRaw)) {
    return(AsCommentsDF(EmptyCommentsDF()))
  }
  EnframeComments(lCommentsRaw) |>
    dplyr::mutate(
      Body = stringr::str_trim(.data$Body),
      Author = ExtractName(.data$Author, "login"),
      CreatedAt = as.POSIXct(.data$CreatedAt, tz = "UTC"),
      UpdatedAt = as.POSIXct(.data$UpdatedAt, tz = "UTC"),
      qcthatCommentID = ExtractQcthatCommentID(.data$Body)
    ) |>
    AsCommentsDF()
}

#' Transform comments list into tibble with expected columns
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with raw comments data.
#' @keywords internal
EnframeComments <- function(lCommentsRaw) {
  dfComments <- tibble::enframe(lCommentsRaw, name = NULL) |>
    tidyr::unnest_wider("value") |>
    dplyr::select(
      dplyr::any_of(c(
        Body = "body",
        Url = "html_url",
        CommentGHID = "id",
        Author = "user",
        CreatedAt = "created_at",
        UpdatedAt = "updated_at"
      ))
    )

  # Bind to the "standard" empty to ensure all columns are present.
  dplyr::bind_rows(
    EmptyCommentsDFRaw(),
    dfComments
  )
}

#' Empty comments data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyCommentsDF <- function() {
  tibble::tibble(
    Body = character(),
    Url = character(),
    CommentGHID = double(),
    Author = character(),
    CreatedAt = as.POSIXct(character()),
    UpdatedAt = as.POSIXct(character()),
    qcthatCommentID = character()
  )
}

#' Empty comments data frame (raw)
#'
#' @returns A standard [tibble::tibble()] with the correct columns (before
#'   transformations) but no rows.
#' @keywords internal
EmptyCommentsDFRaw <- function() {
  tibble::tibble(
    Body = character(),
    Url = character(),
    CommentGHID = double(),
    Author = list(),
    CreatedAt = character(),
    UpdatedAt = character()
  )
}

#' Assign the qcthat_Comments class to a data frame
#'
#' @inheritParams AsExpected
#' @returns A `qcthat_Comments` object.
#' @keywords internal
AsCommentsDF <- function(x) {
  AsExpected(
    x,
    EmptyCommentsDF(),
    chrClass = "qcthat_Comments"
  )
}

#' Extract the qcthat-comment-id from a comment body
#'
#' @inheritParams shared-params
#' @returns A character vector with the extracted `qcthat-comment-id`, or `NA`.
#' @keywords internal
ExtractQcthatCommentID <- function(strBody) {
  stringr::str_extract(
    strBody,
    "qcthat-comment-id:\\s+(\\S+)",
    group = 1
  )
}
