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

  # Fetch all PRs once to avoid repeated API calls
  lPRs <- FetchRawRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = "all"
  )

  MapIssueClosersToCommits(
    dfIssueClosers,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lPRs = lPRs
  )
}

#' Add Commits list column to dfIssueClosers
#'
#' @param dfIssueClosers (`data.frame`) The [tibble::tibble()] returned by
#'   [FetchRepoIssueClosers()].
#' @param lPRs (`list` or `NULL`) Optional list of raw pull request objects as
#'   returned by [FetchRawRepoPRs()]. If provided, PRs will be looked up from
#'   this list instead of fetching individually from the API.
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number (integer).
#'   - `Commits`: List column containing character vectors of commit SHAs
#'   associated with each issue.
MapIssueClosersToCommits <- function(
  dfIssueClosers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  lPRs = NULL
) {
  # Cache for commit lookups to avoid duplicate API calls for the same PR
  commit_cache <- new.env(parent = emptyenv())

  dfIssueClosers$Commits <- purrr::pmap(
    list(
      dfIssueClosers$CloserType,
      dfIssueClosers$CloserSHA,
      dfIssueClosers$CloserPRNumber
    ),
    \(strCloserType, strCloserSHA, intCloserPRNumber) {
      # Create a cache key for this combination
      cache_key <- paste(
        strCloserType,
        strCloserSHA,
        intCloserPRNumber,
        sep = "|"
      )

      # Check if we've already fetched this
      if (exists(cache_key, envir = commit_cache)) {
        return(get(cache_key, envir = commit_cache)) # nocov
      }

      # Fetch and cache the result
      result <- FindAllIssueCommits(
        strCloserType = strCloserType,
        strCloserSHA = strCloserSHA,
        intCloserPRNumber = intCloserPRNumber,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        lPRs = lPRs
      )
      assign(cache_key, result, envir = commit_cache)
      result
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
#' @param lPRs (`list` or `NULL`) Optional list of raw pull request objects as
#'   returned by [FetchRawRepoPRs()]. If provided, PRs will be looked up from
#'   this list instead of fetching individually from the API.
#' @inheritParams shared-params
#' @returns A character vector of commit SHAs associated with this issue.
FindAllIssueCommits <- function(
  strCloserType,
  strCloserSHA,
  intCloserPRNumber,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  lPRs = NULL
) {
  if (!isTRUE(strCloserType == "PullRequest")) {
    return(strCloserSHA)
  }
  chrPRRefs <- FetchPRRefs(
    intPRNumber = intCloserPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lPRs = lPRs
  )
  FetchMergeCommitSHAs(
    strSourceRef = chrPRRefs[["strSourceRef"]],
    strTargetRef = chrPRRefs[["strTargetRef"]],
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}
