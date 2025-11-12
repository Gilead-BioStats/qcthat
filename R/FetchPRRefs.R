#' Fetch the source and target refs for a PR
#'
#' @inheritParams shared-params
#' @returns A named character vector with `strSourceRef` and `strTargetRef`.
#' @keywords internal
FetchPRRefs <- function(
  intPRNumber = FetchLatestRepoPRNumber(strOwner, strRepo, strGHToken, "open"),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
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
    cli::cli_abort(
      c(
        "{.arg intPRNumber} must refer to a pull request in the specified repository.",
        i = "Pull request number {.val {intPRNumber}} not found in repository {.val {strOwner}/{strRepo}}."
      ),
      class = "qcthat-error-pr_not_found",
      call = envCall
    )
  }
  return(c(
    strSourceRef = dfPR$HeadRef,
    strTargetRef = dfPR$BaseRef
  ))
}
