#' Generate a QC report of issues associated with a GitHub merge
#'
#' Finds all commits in `strSourceRef` that are not in `strTargetRef`, finds all
#' pull requests associated with those commits, finds all issues associated with
#' those pull requests, and generates a QC report for those issues.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that are associated with pull requests that will be
#'   merged when `strSourceRef` is merged into `strTargetRef`.
#' @export
#'
#' @examplesIf interactive()
#'
#'   # This will only make sense if you are working in a git repository and have
#'   # an active branch that is different from the default branch.
#'   QCMergeGH()
QCMergeGH <- function(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
) {
  chrCommitSHAs <- FetchMergeCommitSHAs(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
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
  QCIssues(
    intPRIssues,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lglWarn = lglWarn,
    chrIgnoredLabels = chrIgnoredLabels
  )
}

#' Fetch commit SHAs from a comparison
#'
#' @inheritParams shared-params
#' @returns (`character`) A sorted, unique vector of commit SHAs.
#' @keywords internal
FetchMergeCommitSHAs <- function(
  strSourceRef,
  strTargetRef,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lCompareRaw <- CallGHAPI(
    "GET /repos/{owner}/{repo}/compare/{target}...{source}",
    strOwner = strOwner,
    strRepo = strRepo,
    target = strTargetRef,
    source = strSourceRef,
    strGHToken = strGHToken
  )
  return(
    as.character(CompletelyFlatten(purrr::map_chr(lCompareRaw$commits, "sha")))
  )
}

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
