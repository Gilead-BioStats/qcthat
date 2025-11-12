#' Fetch all PR numbers associated with a vector of commit SHAs
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated PR numbers.
#' @keywords internal
FetchAllMergePRNumbers <- function(
  chrCommitSHAs,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  if (!length(chrCommitSHAs)) {
    return(integer(0))
  }
  lPRNumbers <- FetchAllMergePRNumbersRaw(
    chrCommitSHAs = chrCommitSHAs,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  return(as.integer(CompletelyFlatten(lPRNumbers)))
}

#' Fetch associated PR data for commits via GraphQL
#'
#' @inheritParams shared-params
#' @returns A raw list response from the [gh::gh_gql()] call.
#' @keywords internal
FetchAllMergePRNumbersRaw <- function(
  chrCommitSHAs,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  strAllCommitQueries <- paste(
    purrr::imap_chr(chrCommitSHAs, BuildCommitPRQuery),
    collapse = "\n"
  )
  FetchGQL(
    strAllCommitQueries,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Build a GraphQL sub-query for a single commit's PRs
#'
#' @param chrSHA (`length-1 character`) The commit SHA.
#' @param intIndex (`length-1 integer`) A unique index for the query alias.
#' @returns A character string for the GraphQL sub-query.
#' @keywords internal
BuildCommitPRQuery <- function(chrSHA, intIndex) {
  PrepareGQLQuery(
    "commit<intIndex>: object(oid: \"<chrSHA>\") {",
    "  ... on Commit {",
    "    associatedPullRequests(first: 100) { nodes { number } }",
    "  }",
    "}",
    intIndex = intIndex,
    chrSHA = chrSHA
  )
}
