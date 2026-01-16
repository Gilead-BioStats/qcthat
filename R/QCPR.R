#' Generate a QC report of issues associated with a GitHub pull request
#'
#' Find issues associated with a GitHub pull request, whether they were added
#' via keywords, using the pull request sidebar, or using the issue sidebar. See
#' [GitHub Docs: Link a pull request to an
#' issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
#' for details on how issues can become associated with a pull request.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that will be closed by merging the pull request.
#' @seealso [QCMergeLocal()] to use local git data to guess connections between
#'   issues and the commits that closed them.
#' @export
#'
#' @examplesIf interactive()
#'
#'   # You must have at least one pull request open in the GitHub repository
#'   # associated with the current git repository for this to return any
#'   # results.
#'   QCPR()
QCPR <- function(
  intPRNumber = GuessPRNumber(strPkgRoot, strOwner, strRepo, strGHToken),
  intPageMax = 100L,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels()
) {
  if (!length(intPRNumber)) {
    qcthatAbort(
      "Could not guess pull request number. Please provide `intPRNumber`.",
      strErrorSubclass = "pr_number_not_found"
    )
  }
  chrPRRefs <- FetchPRRefs(
    intPRNumber = intPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  QCMergeGH(
    strSourceRef = chrPRRefs[["strSourceRef"]],
    strTargetRef = chrPRRefs[["strTargetRef"]],
    intPageMax = intPageMax,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lglWarn = lglWarn,
    chrIgnoredLabels = chrIgnoredLabels
  )
}

#' Fetch the source and target refs for a PR
#'
#' @inheritParams shared-params
#' @returns A named character vector with `strSourceRef` and `strTargetRef`.
#' @keywords internal
FetchPRRefs <- function(
  intPRNumber = GuessPRNumber(".", strOwner, strRepo, strGHToken),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  lPR <- FetchRawRepoPRSingle(
    intPRNumber = intPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (isTRUE(lPR$merged) && !is.null(lPR$merge_commit_sha)) {
    lCommit <- CallGHAPI(
      "GET /repos/{owner}/{repo}/commits/{ref}",
      strOwner = strOwner,
      strRepo = strRepo,
      ref = lPR$merge_commit_sha,
      strGHToken = strGHToken
    )
    return(c(
      strSourceRef = lPR$merge_commit_sha,
      strTargetRef = lCommit$parents[[1]]$sha
    ))
  }
  return(c(
    strSourceRef = lPR$head$ref,
    strTargetRef = lPR$base$ref
  ))
}
