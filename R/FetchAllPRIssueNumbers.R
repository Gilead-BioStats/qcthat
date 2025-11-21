#' Fetch all issue numbers associated with a vector of PRs
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @keywords internal
FetchAllPRIssueNumbers <- function(
  intPRNumbers,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  if (!length(intPRNumbers)) {
    return(integer(0))
  }
  lIssues <- FetchAllPRIssueNumbersRaw(
    intPRNumbers = intPRNumbers,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  return(as.integer(CompletelyFlatten(lIssues)))
}


#' Fetch associated issue data for pull requests via GraphQL
#'
#' @inheritParams shared-params
#' @returns A raw list response from the [gh::gh_gql()] call.
#' @keywords internal
FetchAllPRIssueNumbersRaw <- function(
  intPRNumbers,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  strAllPRQueries <- paste(
    purrr::map_chr(intPRNumbers, BuildPRIssuesQuery),
    collapse = "\n"
  )
  FetchGQL(
    strAllPRQueries,
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
