#' Fetch commit SHAs for multiple PRs using GitHub GraphQL API
#'
#' Fetches all commits for each PR using batched GraphQL queries so that the
#' number of API calls scales with the number of PRs divided by the batch size,
#' not the number of PRs.
#'
#' @param intPRNumbers (`integer`) A vector of PR numbers.
#' @inheritParams shared-params
#' @returns A list of character vectors, one per element of `intPRNumbers`, each
#'   containing the commit SHAs for that PR.
#' @keywords internal
FetchAllPRCommitSHAs <- function(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!length(intPRNumbers)) {
    return(list())
  }
  intBatchSize <- 25L
  lBatches <- unname(
    split(intPRNumbers, ceiling(seq_along(intPRNumbers) / intBatchSize))
  )
  purrr::map(lBatches, function(intBatch) {
    FetchPRCommitSHAsBatch(
      intPRNumbers = intBatch,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }) |>
    purrr::list_flatten()
}

#' Fetch commit SHAs for a batch of PRs in one GraphQL query
#'
#' @param intPRNumbers (`integer`) A batch of PR numbers to query together.
#' @inheritParams shared-params
#' @returns A list of character vectors, one per element of `intPRNumbers`.
#' @keywords internal
FetchPRCommitSHAsBatch <- function(
  intPRNumbers,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strFragments <- paste(
    purrr::map_chr(intPRNumbers, BuildPRCommitsFragment),
    collapse = "\n"
  )
  lResult <- FetchGQL(
    strFragments,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  lRepo <- lResult$data$repository
  purrr::map(intPRNumbers, function(intPR) {
    lPRData <- lRepo[[paste0("pr", intPR)]]
    ExtractPRCommitSHAs(
      lPRData,
      intPR,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  })
}

#' Build a GraphQL fragment for a single PR's commits
#'
#' @param intPR (`integer(1)`) PR number.
#' @returns A character string with the aliased GraphQL fragment.
#' @keywords internal
BuildPRCommitsFragment <- function(intPR) {
  PrepareGQLQuery(
    "pr<intPR>: pullRequest(number: <intPR>) {",
    "  commits(first: 100) {",
    "    nodes { commit { oid } }",
    "    pageInfo { hasNextPage endCursor }",
    "  }",
    "}",
    intPR = intPR
  )
}

#' Build a paginated GraphQL fragment for a PR's commits
#'
#' @param intPR (`integer(1)`) PR number.
#' @param strCursor (`character(1)`) Pagination cursor.
#' @returns A character string with the GraphQL fragment.
#' @keywords internal
BuildPRCommitsFragmentPaginated <- function(intPR, strCursor) {
  PrepareGQLQuery(
    "pullRequest(number: <intPR>) {",
    '  commits(first: 100, after: "<strCursor>") {',
    "    nodes { commit { oid } }",
    "    pageInfo { hasNextPage endCursor }",
    "  }",
    "}",
    intPR = intPR,
    strCursor = strCursor
  )
}

#' Extract commit SHAs from a PR node, handling pagination
#'
#' @param lPRData (`list`) The `pullRequest` node from the GraphQL response.
#' @param intPR (`integer(1)`) PR number (used for follow-up pagination queries).
#' @inheritParams shared-params
#' @returns A character vector of commit SHAs.
#' @keywords internal
ExtractPRCommitSHAs <- function(
  lPRData,
  intPR,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lCommits <- lPRData$commits
  chrOIDs <- vapply(lCommits$nodes, \(n) n$commit$oid, character(1))
  while (isTRUE(lCommits$pageInfo$hasNextPage)) {
    strCursor <- lCommits$pageInfo$endCursor
    lNext <- FetchGQL(
      BuildPRCommitsFragmentPaginated(intPR, strCursor),
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    lCommits <- lNext$data$repository$pullRequest$commits
    chrOIDs <- c(
      chrOIDs,
      vapply(lCommits$nodes, \(n) n$commit$oid, character(1))
    )
  }
  chrOIDs
}
