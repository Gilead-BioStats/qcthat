#' Fetch commit SHAs for multiple merged PRs using a single local git log
#'
#' Fetches the full repository log once and resolves all PR commit sets in R,
#' replacing the per-PR calls to [GetGitAheadBehind()] and [GetGitLog()]. Parent
#' SHAs are retrieved in batch via [BatchLookupCommitParents()] (using `git2r`),
#' which is much faster than per-commit [gert::git_commit_info()] calls in large
#' repositories.
#'
#' @param chrMergeSHAs (`character`) A vector of merge commit SHAs.
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
  rlang::check_installed("git2r", "to load git commit histories")
  repo <- git2r::repository(strPkgRoot)
  lapply(chrSHAs, function(strSHA) {
    tryCatch(
      {
        lCommit <- git2r::lookup(repo, strSHA)
        lParents <- git2r::parents(lCommit)
        vapply(lParents, git2r::sha, character(1))
      },
      error = function(e) character()
    )
  })
  # nocov end
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
