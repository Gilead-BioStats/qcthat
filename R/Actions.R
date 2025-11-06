#' Install an action from qcthat into a package repo
#'
#' @inheritParams shared-params
#' @returns The path to the created GitHub Action YAML file (invisibly).
#' @keywords internal
InstallAction <- function(
  strActionName,
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
) {
  # Note: I intended for this to be a wrapper around
  # usethis::use_github_action(), but the url of the action would have to be
  # hard-coded, and I don't want to point at dev (or, worse, hack it to point at
  # this branch while I develop this feature). I'd rather keep the action
  # associated with a specific release, to avoid weird bugs. That DOES mean we
  # need to update the package in order to update the action, but I think I
  # prefer that. (@jonthegeek, 2025-11-07)
  strActionName <- paste("qcthat", strActionName, sep = "-")
  InstallFile(
    chrSourcePath = c("workflows", strActionName),
    chrTargetPath = c(".github", "workflows", strActionName),
    strExtension = "yaml",
    lglOverwrite = lglOverwrite,
    strPkgRoot = strPkgRoot,
    envCall = envCall
  )
}

#' Use a GitHub Action to QC completed issues
#'
#' Install a GitHub Action into a package repository to generate a QC report of
#' completed issues with [QCCompletedIssues()]. We recommend reviewing the
#' generated action to determine whether you would like to turn any features
#' off.
#'
#' @inheritParams shared-params
#' @returns The path to the created GitHub Action YAML file (invisibly).
#' @export
#'
#' @examplesIf interactive()
#'
#'   Action_QCCompletedIssues()
Action_QCCompletedIssues <- function(lglOverwrite = FALSE, strPkgRoot = ".") {
  InstallAction("completed_issues", strPkgRoot, lglOverwrite)
}
