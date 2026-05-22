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
  strActionFilename <- fs::path_ext_set(strActionName, "yaml")
  strInstallPath <- fs::path(
    strPkgRoot,
    ".github",
    "workflows",
    strActionFilename
  )
  if (!lglOverwrite && FileExists(strInstallPath)) {
    qcthatAbort(
      c(
        "A GitHub Action YAML file already exists at {.path {strInstallPath}}. ",
        i = "Set `lglOverwrite = TRUE` to overwrite it."
      ),
      strErrorSubclass = "action_exists",
      envCall = envCall
    )
  }
  UseActionInProject(strActionFilename, strPkgRoot)
  return(invisible(strInstallPath))
}

#' Use a GitHub Action in a project
#'
#' @param strActionFilename (`length-1 character`) The filename of the GitHub
#'   Action YAML file.
#' @param strPkgRoot (`length-1 character`) The root directory of the package.
#' @returns (`length-1 character`) The URL of the GitHub Action YAML file that
#'   was added.
#' @keywords internal
UseActionInProject <- function(
  strActionFilename,
  strPkgRoot = "."
) {
  # nocov start
  strSourceURL <- fs::path(
    "Gilead-BioStats/qcthat/.github/workflows/",
    strActionFilename
  )
  usethis::with_project(
    strPkgRoot,
    usethis::use_github_action(
      url = strSourceURL,
      ref = "federated-action",
      open = FALSE,
      ignore = FALSE
    )
  )
  invisible(strSourceURL)
  # nocov end
}

#' Use a GitHub Action to manage qcthat
#'
#' Install a GitHub Action into a package repository to manage qcthat Quality
#' Control with [TriggerUAT()], [CommentAllReports()], and
#' [AttachReleaseReports()]. We recommend reviewing the generated action to
#' determine whether you would like to turn any features off.
#'
#' @inheritParams shared-params
#' @returns The path to the created GitHub Action YAML file (invisibly).
#' @export
#' @examplesIf interactive()
#'
#'   Action_qcthat()
Action_qcthat <- function(lglOverwrite = FALSE, strPkgRoot = ".") {
  InstallAction(
    "qcthat",
    strPkgRoot = strPkgRoot,
    lglOverwrite = lglOverwrite
  )
}
