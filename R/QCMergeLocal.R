#' Generate a QC report of issues probably related to changes between local git
#' refs
#'
#' Find issues associated with merging a source ref into a target ref based
#' purely on GitHub commit keywords, and generate a report about their test
#' status. This report is useful while you're developing a feature on a branch
#' other than the default branch, but you have not yet created a pull request on
#' GitHub.
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_IssueTestMatrix` object as returned by [QCPackage()],
#'   filtered to issues that will be closed by merging `strSourceRef` into
#'   `strTargetRef`, using the [GitHub keywords for linking issues to pull
#'   requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword).
#' @seealso [QCMergeGH()] to use the GitHub API to find more formal, concrete
#'   connections between issues and the commits that closed them, and [QCPR()]
#'   for a wrapper around [QCMergeGH()] that specifically looks at the commits
#'   associated with a specified pull request.
#' @export
#'
#' @examplesIf interactive()
#'
#'   # This will only make sense if you are working in a git repository and have
#'   # an active branch that is different from the default branch.
#'   QCMergeLocal()
QCMergeLocal <- function(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  chrKeywords = c(
    "close",
    "closes",
    "closed",
    "fix",
    "fixes",
    "fixed",
    "resolve",
    "resolves",
    "resolved"
  ),
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  intMaxCommits = 100000L
) {
  intAssociatedIssues <- FindKeywordIssues(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
    strPkgRoot = strPkgRoot,
    chrKeywords = chrKeywords,
    strOwner = strOwner,
    strRepo = strRepo,
    intMaxCommits = intMaxCommits
  )
  QCIssues(
    intAssociatedIssues,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    lglWarn = lglWarn,
    chrIgnoredLabels = chrIgnoredLabels
  )
}

#' Find issues that will be closed by merging one branch into another
#'
#' @inheritParams shared-params
#' @returns An integer vector of issue numbers in this repo that will be closed
#'   by merging `strSourceRef` into `strTargetRef`, using the [GitHub keywords
#'   for linking issues to pull
#'   requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword).
#' @keywords internal
FindKeywordIssues <- function(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  chrKeywords = c(
    "close",
    "closes",
    "closed",
    "fix",
    "fixes",
    "fixed",
    "resolve",
    "resolves",
    "resolved"
  ),
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  intMaxCommits = 100000L
) {
  strPkgRoot <- GetPkgRoot(strPkgRoot)
  dfCommits <- CompileGitLogDiff(
    strSourceRef = strSourceRef,
    strTargetRef = strTargetRef,
    strPkgRoot = strPkgRoot,
    intMaxCommits = intMaxCommits
  )
  ExtractGHClosingIssues(
    dfCommits[["message"]],
    chrKeywords = chrKeywords,
    strOwner = strOwner,
    strRepo = strRepo
  )
}

#' Determine the active branch of a git repository
#'
#' @inheritParams shared-params
#' @returns A length-1 character vector representing the active branch name.
#' @keywords internal
GetActiveBranch <- function(strPkgRoot = ".") {
  # Tested manually

  # nocov start
  gert::git_branch(strPkgRoot)
  # nocov end
}

#' Determine the default branch of a git repository
#'
#' @inheritParams shared-params
#' @returns A length-1 character vector representing the default branch name.
#' @keywords internal
GetDefaultBranch <- function(strPkgRoot = ".") {
  # Tested manually

  # nocov start
  rlang::check_installed("usethis", "to find the default branch of the repo.")
  usethis::with_project(
    strPkgRoot,
    usethis::git_default_branch(),
    quiet = TRUE
  )
  # nocov end
}

#' Create a data frame of commits that are in one git ref but not another
#'
#' @inheritParams shared-params
#' @returns A data frame of commits that are in `strSourceRef` but not in
#'   `strTargetRef`, as returned by [GetGitLog()].
#' @keywords internal
CompileGitLogDiff <- function(
  strSourceRef,
  strTargetRef,
  strPkgRoot = ".",
  intMaxCommits = 100000L
) {
  dfSourceLog <- GetGitLog(strSourceRef, strPkgRoot, intMaxCommits)
  dfTargetLog <- GetGitLog(strTargetRef, strPkgRoot, intMaxCommits)
  return(dplyr::anti_join(dfSourceLog, dfTargetLog, by = "commit"))
}

#' List commits in a git reference
#'
#' @inheritParams shared-params
#' @returns A data frame of commits that are in `strGitRef`, as returned by
#'   [gert::git_log()].
#' @keywords internal
GetGitLog <- function(strGitRef, strPkgRoot = ".", intMaxCommits = 100000) {
  # Tested manually

  # nocov start
  gert::git_log(
    repo = strPkgRoot,
    ref = strGitRef,
    max = intMaxCommits
  )
  # nocov end
}

#' Extract closing issue numbers from commit messages
#'
#' @inheritParams shared-params
#' @returns An integer vector of issue numbers found in `chrCommitMessages` that
#'   will be closed according to GitHub's keywords for linking issues to pull
#'   requests.
#' @keywords internal
ExtractGHClosingIssues <- function(
  chrCommitMessages,
  chrKeywords = c(
    "close",
    "closes",
    "closed",
    "fix",
    "fixes",
    "fixed",
    "resolve",
    "resolves",
    "resolved"
  ),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo()
) {
  stringr::str_extract_all(
    chrCommitMessages,
    GHKeywordRegex(chrKeywords, strOwner, strRepo)
  ) |>
    # We don't care whether it was multiple in one message vs multiple messages.
    unlist() |>
    # This doesn't need to be str_extract_all because the first all already
    # separated them into individual issue references.
    stringr::str_extract("#(\\d+)", group = 1) |>
    unique() |>
    sort() |>
    as.integer()
}

#' Compile the regex used to find GitHub-closing issues in commit messages
#'
#' @inheritParams shared-params
#' @returns A length-1 character vector containing the regex pattern.
#' @keywords internal
GHKeywordRegex <- function(
  chrKeywords = c(
    "close",
    "closes",
    "closed",
    "fix",
    "fixes",
    "fixed",
    "resolve",
    "resolves",
    "resolved"
  ),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo()
) {
  strKeywordsRegex <- paste(chrKeywords, collapse = "|")
  glue::glue(
    "(?i)({strKeywordsRegex})\\s+(({strOwner}/{strRepo}#(\\d+))|(#(\\d+)))"
  )
}
