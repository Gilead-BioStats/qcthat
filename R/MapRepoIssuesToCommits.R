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

  MapIssueClosersToCommits(
    dfIssueClosers,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strPkgRoot = strPkgRoot
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
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  dfClosers <- dplyr::distinct(
    dfIssueClosers,
    .data$CloserType,
    .data$CloserSHA,
    .data$CloserPRNumber
  )
  dfClosers$Commits <- as.list(dfClosers$CloserSHA)

  lglIsPR <- dfClosers$CloserType == "PullRequest"
  if (any(lglIsPR)) {
    lPRCommits <- FetchAllPRCommitSHAs(
      dfClosers$CloserPRNumber[lglIsPR],
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    # Include the merge SHA (matches git blame for squash-merged PRs) alongside
    # individual branch commits (matches git blame for regular merges).
    dfClosers$Commits[lglIsPR] <- purrr::map2(
      dfClosers$CloserSHA[lglIsPR],
      lPRCommits,
      \(x, y) unique(c(x, y))
    )
  }

  dfIssueClosers |>
    dplyr::left_join(
      dfClosers,
      by = c("CloserType", "CloserSHA", "CloserPRNumber")
    ) |>
    dplyr::select("Issue", "Commits")
}
