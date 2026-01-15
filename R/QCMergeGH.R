#' Generate a QC report of issues associated with a GitHub merge
#'
#' Finds all commits in `strSourceRef` that are not in `strTargetRef`, finds all
#' pull requests associated with those commits, finds all issues associated with
#' those pull requests (according to GitHub's graph of connections between
#' issues and commits), and generates a QC report for those issues. This is a
#' more robust check than [QCMergeLocal()]. Note: If the comparison involves
#' more than 5000 commits, increase `intPageMax` to fetch additional commits in
#' batches of 100.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that are associated with pull requests that will be
#'   merged when `strSourceRef` is merged into `strTargetRef`.
#' @seealso [QCMergeLocal()] to use local git data to guess connections between
#'   issues and the commits that closed them.
#' @export
#'
#' @examplesIf interactive()
#'
#'   # This will only make sense if you are working in a git repository and have
#'   # an active branch that is different from the default branch. QCMergeGH()
QCMergeGH <- function(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  intPageMax = 100L,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
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
  intClosedIssues <- FetchAllMergeIssueNumbers(
    intPRNumbers,
    chrCommitSHAs,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  QCIssues(
    sort(unique(c(intPRIssues, intClosedIssues))),
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
    lAllCommits <- c(lAllCommits, lNext$commits)
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

#' Fetch a vector of values from GitHub GraphQL API using a builder function
#'
#' @param x (`vector`) A vector of inputs to process.
#' @param fnBuildQuery (`function`) A function that takes a single element of
#'   `x` and returns a character string representing a GraphQL sub-query for
#'   that element.
#' @param vecProto (`vector`) A prototype vector to return if `x` is empty.
#' @inheritParams shared-params
#' @returns A sorted, unique vector of values fetched from GitHub, or
#'   `vecProto`.
#' @keywords internal
FetchVectorFromGQL <- function(
  x,
  fnBuildQuery,
  vecProto = integer(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!length(x)) {
    return(vecProto)
  }
  intBatchSize <- 50
  lBatches <- unname(split(x, ceiling(seq_along(x) / intBatchSize)))
  lAllResults <- purrr::map(lBatches, function(vecBatch) {
    FetchGQL(
      paste(purrr::map_chr(vecBatch, fnBuildQuery), collapse = "\n"),
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  })
  vecPrepared <- CompletelyFlatten(lAllResults) %||% vecProto
  return(vecPrepared)
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

#' Fetch all issue numbers associated with a merge
#'
#' @inheritParams shared-params
#' @returns A sorted, unique integer vector of associated issue numbers.
#' @keywords internal
FetchAllMergeIssueNumbers <- function(
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
    dplyr::pull("Issue")
}
