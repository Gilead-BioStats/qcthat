#' Guess the most relevant pull request number
#'
#' Tries to find a pull request associated with the active branch.
#'
#' @inheritParams shared-params
#'
#' @returns The associated pull request number as an integer, or `NULL` if no
#'   pull requests are found.
#' @export
#'
#' @examplesIf interactive()
#'
#'   GuessPRNumber()
GuessPRNumber <- function(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  GetGHAPRNumber() %||%
    NullIfEmpty(
      FetchRefPRNumber(
        strSourceRef = GetActiveBranch(strPkgRoot),
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    )
}

#' Get the PR number for a GitHub Action
#'
#' @returns An integer pull request number, or `NULL` if not running in a
#'   PR-triggered action (as indicated by the environment variables
#'   `"GITHUB_EVENT_NAME"` and `"GITHUB_REF_NAME"`).
#' @keywords internal
GetGHAPRNumber <- function() {
  if (identical(Sys.getenv("GITHUB_EVENT_NAME"), "pull_request")) {
    strPREnv <- stringr::str_extract(Sys.getenv("GITHUB_REF_NAME"), "^\\d+")
    if (!is.na(strPREnv) && nzchar(strPREnv)) {
      return(as.integer(strPREnv))
    }
  }
}

#' Fetch the pull request number for a branch or other git ref
#'
#' @inheritParams shared-params
#'
#' @returns An integer pull request number, or `integer()` if no matching PR
#'   (or more than one matching PR) is found.
#' @export
#'
#' @examplesIf interactive()
#'
#'   FetchRefPRNumber()
FetchRefPRNumber <- function(
  strSourceRef = GetActiveBranch(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfPRs <- FetchRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = "all"
  ) |>
    dplyr::filter(.data$HeadRef == strSourceRef)

  if (!NROW(dfPRs)) {
    return(integer())
  }
  if (NROW(dfPRs) == 1L) {
    return(dfPRs$PR)
  }
  cli::cli_warn(c(
    "Multiple PRs found. Returning `integer()`.",
    i = "PRs: {dfPRs$PR}"
  ))
  return(integer())
}
