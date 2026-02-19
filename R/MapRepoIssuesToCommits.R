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
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
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
    lPRs = lPRs,
    strPkgRoot = strPkgRoot
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
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lPRs = NULL
) {
  dfClosers <- dplyr::distinct(
    dfIssueClosers,
    .data$CloserType,
    .data$CloserSHA,
    .data$CloserPRNumber
  )
  # Prep lPRs for speed.
  if (length(lPRs)) {
    names(lPRs) <- purrr::map_int(lPRs, "number")
  }
  dfClosers$Commits <- as.list(dfClosers$CloserSHA)

  lglIsPR <- dfClosers$CloserType == "PullRequest"
  if (any(lglIsPR)) {
    chrPRMergeSHAs <- purrr::map_chr(
      dfClosers$CloserPRNumber[lglIsPR],
      \(intCloserPRNumber) {
        LookupPRFromList(lPRs, intCloserPRNumber)$merge_commit_sha
      }
    )
    lPRCommits <- FetchAllMergeCommitSHAsLocal(chrPRMergeSHAs, strPkgRoot)
    dfClosers$Commits[lglIsPR] <- lPRCommits
  }

  dfIssueClosers |>
    dplyr::left_join(
      dfClosers,
      by = c("CloserType", "CloserSHA", "CloserPRNumber")
    ) |>
    dplyr::select("Issue", "Commits")
}
