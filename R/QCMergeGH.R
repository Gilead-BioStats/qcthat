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
#'   # an active branch that is different from the default branch.
#'
#'   QCMergeGH()
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
  dfITM = NULL,
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
    chrIgnoredLabels = chrIgnoredLabels,
    dfITM = dfITM
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

#' Fetch commit SHAs for multiple merged PRs using a single local git log
#'
#' Fetches the full repository log once and resolves all PR commit sets in R,
#' replacing the per-PR calls to [GetGitAheadBehind()] and [GetGitLog()]. Parent
#' SHAs are retrieved in batch via [BatchLookupCommitParents()] (using `git2r`),
#' which is much faster than per-commit [gert::git_commit_info()] calls in large
#' repositories.
#'
#' @param chrMergeSHAs (`character`) A vector of merge commit SHAs.
#' @param intMaxCommits (`length-1 integer`) Maximum number of commits to fetch
#'   from the log. Increase if the repository history exceeds this number.
#' @inheritParams shared-params
#' @returns A named list, one element per element of `chrMergeSHAs`, each a
#'   character vector of commit SHAs introduced by that PR.
#' @keywords internal
FetchAllMergeCommitSHAsLocal <- function(
  chrMergeSHAs,
  strPkgRoot = ".",
  intMaxCommits = 100000L
) {
  if (!length(chrMergeSHAs)) {
    return(list())
  }
  # Fetch the full log once. This gives us a topological ordering of commits
  # (most recent first) which we use to resolve ancestry without additional
  # git calls.
  chrAllCommits <- GetGitLog(
    strGitRef = "HEAD",
    strPkgRoot = strPkgRoot,
    intMaxCommits = intMaxCommits
  )$commit
  # Build an environment (hash set) for O(1) membership tests.
  envCommitIndex <- BuildCommitIndexEnv(chrAllCommits)
  # Look up parents for all merge SHAs in one batch using git2r, which is

  # much faster than calling gert::git_commit_info() per SHA.
  lParents <- BatchLookupCommitParents(chrMergeSHAs, strPkgRoot)
  purrr::map2(
    chrMergeSHAs,
    lParents,
    \(strMergeSHA, chrParents) {
      ResolvePRCommits(strMergeSHA, chrAllCommits, envCommitIndex, chrParents)
    }
  )
}

#' Build an O(1) lookup for commit positions in a log
#'
#' @param chrCommits (`character`) An ordered vector of commit SHAs (most
#'   recent first, as returned by `gert::git_log()`).
#' @returns An environment mapping each SHA to its 1-based position index.
#' @keywords internal
BuildCommitIndexEnv <- function(chrCommits) {
  envIdx <- new.env(hash = TRUE, parent = emptyenv(), size = length(chrCommits))
  for (i in seq_along(chrCommits)) {
    envIdx[[chrCommits[[i]]]] <- i
  }
  envIdx
}

#' Resolve the PR commits for a single merge commit
#'
#' Uses a pre-fetched commit log and index to find all commits reachable from
#' the PR branch tip (parent2) but not from the target branch tip (parent1),
#' without making additional git calls.
#'
#' @param strMergeSHA (`length-1 character`) The merge commit SHA.
#' @param chrAllCommits (`character`) Full ordered commit log (most recent
#'   first) as returned by [GetGitLog()].
#' @param envCommitIndex (`environment`) Named environment mapping SHAs to
#'   positions in `chrAllCommits`, as built by [BuildCommitIndexEnv()].
#' @param chrParents (`character`) Parent SHAs of the merge commit, as returned
#'   by [BatchLookupCommitParents()].
#' @returns A character vector of commit SHAs introduced by this PR.
#' @keywords internal
ResolvePRCommits <- function(
  strMergeSHA,
  chrAllCommits,
  envCommitIndex,
  chrParents
) {
  # No parents found (SHA not in local repo, e.g. a squash-merge SHA that

  # GitHub records but was never fetched), or squash merge (single parent):
  # return the merge commit itself.
  if (length(chrParents) <= 1L) {
    return(strMergeSHA)
  }
  strTargetParent <- chrParents[[1]]
  strPRParent <- chrParents[[2]]
  # The log is topologically ordered most-recent-first. All commits at
  # positions strictly less than the target parent's position are candidates
  # for being on the PR branch. We collect from the PR parent's position up
  # to (but not including) the target parent's position.
  intTargetPos <- envCommitIndex[[strTargetParent]] %||% NA_integer_
  intPRPos <- envCommitIndex[[strPRParent]] %||% NA_integer_
  if (is.na(intPRPos)) {
    # PR branch tip not in log; fall back to the merge SHA.
    return(strMergeSHA)
  }
  if (is.na(intTargetPos) || intPRPos >= intTargetPos) {
    # No commits ahead on PR branch (or target not found).
    return(strMergeSHA)
  }
  chrAllCommits[intPRPos:(intTargetPos - 1L)]
}

#' Wrapper around gert::git_commit_info() for mocking
#'
#' @param strRef (`length-1 character`) A branch, tag, or commit SHA.
#' @inheritParams shared-params
#' @returns The result of [gert::git_commit_info()].
#' @keywords internal
GetGitCommitInfo <- function(strRef, strPkgRoot = ".") {
  # nocov start
  gert::git_commit_info(ref = strRef, repo = strPkgRoot)
  # nocov end
}

#' Look up parent SHAs for multiple commits using git2r
#'
#' Uses [git2r::lookup()] and [git2r::parents()] to efficiently retrieve parent
#' SHAs for many commits in a single repository session. This is much faster
#' than calling [gert::git_commit_info()] per commit for large repositories.
#'
#' If a SHA is not found locally (e.g., a squash-merge commit that GitHub
#' records but never existed in the local history), `character(0)` is returned
#' for that element.
#'
#' @param chrSHAs (`character`) A vector of commit SHAs.
#' @inheritParams shared-params
#' @returns A list of character vectors, one per element of `chrSHAs`, each
#'   containing the parent SHAs for that commit, or `character(0)` if the
#'   commit is not available locally.
#' @keywords internal
BatchLookupCommitParents <- function(chrSHAs, strPkgRoot = ".") {
  # nocov start
  repo <- git2r::repository(strPkgRoot)
  lapply(chrSHAs, function(strSHA) {
    tryCatch(
      {
        lCommit <- git2r::lookup(repo, strSHA)
        lParents <- git2r::parents(lCommit)
        vapply(lParents, git2r::sha, character(1))
      },
      error = function(e) character(0)
    )
  })
  # nocov end
}

#' Wrapper around gert::git_ahead_behind() for mocking
#'
#' @param strUpstream (`length-1 character`) The upstream branch or commit SHA.
#' @param strRef (`length-1 character`) The local branch or commit SHA.
#' @inheritParams shared-params
#' @returns The result of [gert::git_ahead_behind()].
#' @keywords internal
GetGitAheadBehind <- function(strUpstream, strRef, strPkgRoot = ".") {
  # nocov start
  gert::git_ahead_behind(
    upstream = strUpstream,
    ref = strRef,
    repo = strPkgRoot
  )
  # nocov end
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
