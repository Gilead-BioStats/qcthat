#' Fetch all issue numbers associated with a merge
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @keywords internal
FetchMergeIssueNumbers <- function(
  strSourceRef = GetActiveBranch(),
  strTargetRef = GetDefaultBranch(),
  intPageMax = 100L,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  chrCommitSHAs <- FetchMergeCommitSHAs(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
    intPageMax = intPageMax,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  intPRNumbers <- FetchAllMergePRNumbers(
    chrCommitSHAs,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  intPRIssues <- FetchAllPRIssueNumbers(
    intPRNumbers,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  intClosedIssues <- FetchMergeIssueClosers(
    intPRNumbers,
    chrCommitSHAs,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  sort(unique(c(intPRIssues, intClosedIssues)))
}

#' Fetch commit SHAs from a comparison
#'
#' @inheritParams shared-params
#' @returns (`character`) A sorted, unique vector of commit SHAs.
#' @keywords internal
FetchMergeCommitSHAs <- function(
  strSourceRef,
  strTargetRef,
  intPageMax = 100L,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lAllCommits <- list()
  intTotalCommits <- 0L
  # gh:gh()'s native pagination didn't work well for this, so we're paginating
  # ourselves.
  for (intPage in seq_len(intPageMax)) {
    lNext <- FetchMergeCommitBatchRaw(
      strSourceRef = strSourceRef,
      strTargetRef = strTargetRef,
      intPage = intPage,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    if (!length(lNext$commits)) {
      break
    }
    lAllCommits <- unique(c(lAllCommits, lNext$commits))
    if (!intTotalCommits) {
      intTotalCommits <- lNext$total_commits
    }
    if (length(lAllCommits) >= intTotalCommits) {
      break
    }
  }
  return(
    as.character(CompletelyFlatten(purrr::map_chr(lAllCommits, "sha")))
  )
}

#' Fetch a single page of commits from a comparison
#'
#' @param intPage (`length-1 integer`) The page number to fetch.
#' @inheritParams shared-params
#' @returns A raw list response from the API.
#' @keywords internal
FetchMergeCommitBatchRaw <- function(
  strSourceRef,
  strTargetRef,
  intPage = 1,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "GET /repos/{owner}/{repo}/compare/{target}...{source}",
    strOwner = strOwner,
    strRepo = strRepo,
    target = strTargetRef,
    source = strSourceRef,
    strGHToken = strGHToken,
    .progress = FALSE,
    page = intPage,
    numLimit = 100
  )
}

#' Fetch all PR numbers associated with a vector of commit SHAs
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of merged PR numbers.
#' @keywords internal
FetchAllMergePRNumbers <- function(
  chrCommitSHAs,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchVectorFromGQL(
    chrCommitSHAs,
    fnBuildQuery = BuildCommitPRQuery,
    vecProto = integer(),
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Build a GraphQL sub-query for a single commit's PRs
#'
#' @inheritParams shared-params
#' @returns A character string for the GraphQL sub-query.
#' @keywords internal
BuildCommitPRQuery <- function(strCommitSHA) {
  PrepareGQLQuery(
    "commit<sha>: object(oid: \"<sha>\") {",
    "... on Commit {",
    "associatedPullRequests(first: 1) { nodes { number } }",
    "}",
    "}",
    sha = strCommitSHA
  )
}

#' Fetch all issue numbers associated with a vector of PRs
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @keywords internal
FetchAllPRIssueNumbers <- function(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchVectorFromGQL(
    intPRNumbers,
    fnBuildQuery = BuildPRIssuesQuery,
    vecProto = integer(),
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Build a GraphQL sub-query for a single PR's issues
#'
#' @inheritParams shared-params
#' @returns A character string for the GraphQL sub-query.
#' @keywords internal
BuildPRIssuesQuery <- function(intPRNumber) {
  PrepareGQLQuery(
    "pr<pr_num>: pullRequest(number: <pr_num>) {",
    "closingIssuesReferences(first: 20) { nodes { number } }",
    "}",
    pr_num = intPRNumber
  )
}

#' Fetch issue closers associated with a merge
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @keywords internal
FetchMergeIssueClosers <- function(
  intPRNumbers,
  chrCommitSHAs,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchRepoIssueClosers(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      (.data$CloserSHA %in% chrCommitSHAs) |
        (.data$CloserPRNumber %in% intPRNumbers)
    ) |>
    dplyr::pull("Issue") |>
    unique()
}
