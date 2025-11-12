#' Guess the most relevant pull request number
#'
#' Tries to find a pull request associated with the active branch. If it fails,
#' it falls back to finding the latest pull request number, optionally filtered
#' by state.
#'
#' @inheritParams shared-params
#'
#' @returns The latest pull request number as an integer, or `integer(0)` if no
#'   pull requests are found.
#' @export
#'
#' @examplesIf interactive()
#'
#'   GuessPRNumber()
GuessPRNumber <- function(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token()
) {
  NullIfEmpty(
    FetchRefPRNumber(
      strSourceRef = GetActiveBranch(strPkgRoot),
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  ) %||%
    FetchLatestRepoPRNumber(
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken,
      strState = "open"
    )
}

#' Fetch the latest pull request number for a GitHub repository
#'
#' Fetch the latest pull request number for a GitHub repository, optionally
#' filtered by state.
#'
#' @inheritParams shared-params
#'
#' @returns The latest pull request number as an integer, or `NA_integer_` if no
#'   pull requests are found.
#' @export
#'
#' @examplesIf interactive()
#'
#'   FetchLatestRepoPRNumber()
FetchLatestRepoPRNumber <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
) {
  strState <- match.arg(strState)
  dfPRs <- FetchRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = strState
  ) |>
    dplyr::arrange(dplyr::desc(.data$CreatedAt))
  if (NROW(dfPRs) && length(dfPRs$PR[[1]])) {
    return(dfPRs$PR[[1]])
  } else {
    return(NA_integer_)
  }
}

#' Fetch the pull request number for a branch or other git ref
#'
#' @inheritParams shared-params
#'
#' @returns An integer pull request number, or `integer(0)` if no matching PR
#'   (or more than one matching PR) is found.
#' @export
#'
#' @examplesIf interactive()
#'
#'   FetchRefPRNumber()
FetchRefPRNumber <- function(
  strSourceRef = GetActiveBranch(),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
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
    return(integer(0))
  }
  if (NROW(dfPRs) == 1L) {
    return(dfPRs$PR)
  }
  cli::cli_warn(
    c(
      "Multiple PRs found. Returning `integer(0)`.",
      i = "PRs: {dfPRs$PR}"
    )
  )
  return(integer(0))
}
