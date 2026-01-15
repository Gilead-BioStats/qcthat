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
#' @returns An integer pull request number, or `integer()` if no matching PR is
#'   found. If multiple PRs are found, first, if there are any open PRs, we
#'   filter to only include open PRs, then the PR that was most recently created
#'   is returned.
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
  cli::cli_warn(
    c(
      "Multiple pull requests found for ref {.val {strSourceRef}}.",
      i = "Returning the most recently created pull request (preferring open), if any."
    ),
    class = "qcthat-warning-multiple_prs"
  )
  return(ChooseRefPRNumber(dfPRs, strSourceRef))
}

#' Choose between multiple PRs
#'
#' @param dfPRs (`data.frame`) Data frame of pull requests as returned by
#'   [FetchRepoPRs()].
#' @inheritParams shared-params
#'
#' @returns A `length-1 integer` pull request number.
#' @keywords internal
ChooseRefPRNumber <- function(dfPRs, strSourceRef = GetActiveBranch()) {
  required_fields <- c("PR", "State", "CreatedAt")
  if (!NROW(dfPRs) || !all(required_fields %in% colnames(dfPRs))) {
    cli::cli_abort(
      "{.var dfPRs} must be a dataframe with columns {.field {required_fields}}.",
      class = "qcthat-error-invalid_pr_dataframe"
    )
  }
  if (any(dfPRs$State == "open", na.rm = TRUE)) {
    dfPRs <- dplyr::filter(dfPRs, .data$State == "open")
  }
  if (NROW(dfPRs)) {
    intPR <- dplyr::arrange(dfPRs, dplyr::desc(.data$CreatedAt)) |>
      dplyr::pull(.data$PR)
    return(intPR[[1]])
  }
}
