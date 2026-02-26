#' Fetch issue details from GitHub
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number.
#'   - `Title`: Issue title.
#'   - `Body`: Issue body (or `NA_character_` if NULL).
#' @keywords internal
FetchIssueDetails <- function(
  intIssues,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!length(intIssues)) {
    return(EmptyIssueDetailsDF())
  }
  dfUniqueDetails <- FetchUniqueIssueDetails(
    intIssues,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  ReorderDFByVector(intIssues, "Issue", dfUniqueDetails)
}

#' Create empty issue details data frame
#'
#' @inherit FetchIssueDetails return
#' @keywords internal
EmptyIssueDetailsDF <- function() {
  tibble::tibble(
    Issue = integer(),
    Title = character(),
    Body = character()
  )
}

#' Fetch details for unique issues
#'
#' @inheritParams shared-params
#' @inherit FetchIssueDetails return
#' @keywords internal
FetchUniqueIssueDetails <- function(
  intIssues,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lIssueDetailsDFs <- purrr::map(unique(intIssues), \(intIssue) {
    FetchIssueDetailsSingle(intIssue, strOwner, strRepo, strGHToken)
  })
  purrr::list_rbind(c(list(EmptyIssueDetailsDF()), lIssueDetailsDFs))
}

#' Fetch details for a single issue
#'
#' @inheritParams shared-params
#' @inherit FetchIssueDetails return
#' @keywords internal
FetchIssueDetailsSingle <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lIssue <- FetchIssueDetailsRaw(intIssue, strOwner, strRepo, strGHToken)
  if (length(lIssue)) {
    tibble::tibble(
      Issue = lIssue$number,
      Title = lIssue$title,
      Body = lIssue$body %||% NA_character_
    )
  }
}

#' Fetch raw issue details from GitHub API
#'
#' @inheritParams shared-params
#' @returns A `list` containing raw issue data from the GitHub API.
#' @keywords internal
FetchIssueDetailsRaw <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "GET /repos/{owner}/{repo}/issues/{issue_number}",
    issue_number = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Reorder data frame rows by vector
#'
#' @param vecOrder A vector defining the desired order and repetitions.
#' @param strName (`length-1 character`) Name of the column in `dfUnique` to
#'   join on.
#' @param dfUnique (`data.frame`) Data frame with unique rows to be reordered.
#' @returns A data frame with rows reordered to match `vecOrder`, including
#'   duplicates.
#' @keywords internal
ReorderDFByVector <- function(vecOrder, strName, dfUnique) {
  dplyr::left_join(
    tibble::tibble(!!strName := vecOrder),
    dfUnique,
    by = strName
  )
}
