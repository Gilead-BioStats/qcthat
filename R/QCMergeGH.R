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
  intIssues <- FetchMergeIssueNumbers(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
    intPageMax = intPageMax,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  QCIssues(
    intIssues,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lglWarn = lglWarn,
    chrIgnoredLabels = chrIgnoredLabels,
    dfITM = dfITM
  )
}
