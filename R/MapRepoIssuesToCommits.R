#' Map repository issues to commits
#'
#' Fetch all closed issues in a repository and expand their closers (commits or
#' pull requests) into the set of commits that might be related to each issue.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number (integer).
#'   - `Commits`: List column containing character vectors of commit SHAs
#'   associated with each issue.
#' @keywords internal
MapRepoIssuesToCommits <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfIssueClosers <- FetchRepoIssueClosers(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (!nrow(dfIssueClosers)) {
    return(tibble::tibble(Issue = integer(), Commits = list()))
  }
  MapIssueClosersToCommits(
    dfIssueClosers,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Add Commits list column to dfIssueClosers
#'
#' @param dfIssueClosers (`data.frame`) The [tibble::tibble()] returned by
#'   [FetchRepoIssueClosers()].
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number (integer).
#'   - `Commits`: List column containing character vectors of commit SHAs
#'   associated with each issue.
MapIssueClosersToCommits <- function(
  dfIssueClosers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfIssueClosers$Commits <- purrr::pmap(
    list(
      dfIssueClosers$CloserType,
      dfIssueClosers$CloserSHA,
      dfIssueClosers$CloserPRNumber
    ),
    \(strCloserType, strCloserSHA, intCloserPRNumber) {
      FindAllIssueCommits(
        strCloserType = strCloserType,
        strCloserSHA = strCloserSHA,
        intCloserPRNumber = intCloserPRNumber,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    }
  )
  dplyr::select(dfIssueClosers, "Issue", "Commits")
}

#' Add Commits list column to dfIssueClosers
#'
#' @param strCloserType (`length-1 character`) Whether the issue was closed by a
#'   `"PullRequest"` or a `"Commit"`.
#' @param strCloserSHA (`length-1 character`) The commit SHA for an issue closed
#'   by a `"Commit"`.
#' @param intCloserPRNumber (`length-1 integer`) The number of the pull request
#'   that closed the issue.
#' @inheritParams shared-params
#' @returns A character vector of commit SHAs associated with this issue.
FindAllIssueCommits <- function(
  strCloserType,
  strCloserSHA,
  intCloserPRNumber,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!isTRUE(strCloserType == "PullRequest")) {
    return(strCloserSHA)
  }
  chrPRRefs <- FetchPRRefs(
    intPRNumber = intCloserPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  FetchMergeCommitSHAs(
    strSourceRef = chrPRRefs[["strSourceRef"]],
    strTargetRef = chrPRRefs[["strTargetRef"]],
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}
