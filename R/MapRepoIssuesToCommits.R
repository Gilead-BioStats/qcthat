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
    return(tibble::tibble(
      Issue = integer(),
      Commits = vctrs::list_of(.ptype = character())
    ))
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
  dfClosers <- dplyr::distinct(
    dfIssueClosers,
    .data$CloserType,
    .data$CloserSHA,
    .data$CloserPRNumber
  )

  dfClosers$Commits <- purrr::pmap(
    list(
      dfClosers$CloserType,
      dfClosers$CloserSHA,
      dfClosers$CloserPRNumber
    ),
    \(strCloserType, strCloserSHA, intCloserPRNumber) {
      FindAllIssueCommits(
        strCloserType = strCloserType,
        strCloserSHA = strCloserSHA,
        intCloserPRNumber = intCloserPRNumber,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken,
        lPRs = lPRs
      )
    }
  )
  dfIssueClosers |>
    dplyr::left_join(
      dfClosers,
      by = c("CloserType", "CloserSHA", "CloserPRNumber")
    ) |>
    dplyr::select("Issue", "Commits")
}

#' Find all commits associated with an issue closer
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
