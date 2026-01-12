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
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels()
) {
  chrPRRefs <- FetchPRRefs(
    intPRNumber = intPRNumber,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  QCMergeGH(
    strSourceRef = chrPRRefs[["strSourceRef"]],
    strTargetRef = chrPRRefs[["strTargetRef"]],
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
  dfPR <- FetchRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = "all"
  ) |>
    dplyr::filter(.data$PR == intPRNumber)
  if (!NROW(dfPR)) {
    qcthatAbort(
      c(
        "{.arg intPRNumber} must refer to a pull request in the specified repository.",
        i = "Pull request number {.val {intPRNumber}} not found in repository {.val {strOwner}/{strRepo}}."
      ),
      strErrorSubclass = "pr_not_found",
      envCall = envCall
    )
  }
  return(c(
    strSourceRef = dfPR$HeadRef,
    strTargetRef = dfPR$BaseRef
  ))
}
