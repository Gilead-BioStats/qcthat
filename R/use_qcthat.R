#' Set up qcthat for a package
#'
#' Set up qcthat labels and GitHub Action workflow for a package repository.
#' This function combines [SetupGHLabels()] and [Action_qcthat()] to create
#' the necessary GitHub labels and install the GitHub Action workflow for
#' managing qcthat Quality Control. We recommend reviewing the generated action
#' to determine whether you would like to turn any features off.
#'
#' @inheritParams shared-params
#' @returns `TRUE` (invisibly).
#' @export
#' @examplesIf interactive()
#'
#'   use_qcthat()
use_qcthat <- function(
  dfLabels = DefaultIgnoreLabelsDF(),
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  SetupGHLabels(
    dfLabels = dfLabels,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  Action_qcthat(
    lglOverwrite = lglOverwrite,
    strPkgRoot = strPkgRoot
  )
  return(invisible(TRUE))
}
