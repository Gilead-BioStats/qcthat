#' Fetch commit SHAs from a comparison
#'
#' @inheritParams shared-params
#' @returns (`character`) A sorted, unique vector of commit SHAs.
#' @keywords internal
FetchMergeCommitSHAs <- function(
  strSourceRef,
  strTargetRef,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lCompareRaw <- CallGHAPI(
    "GET /repos/{owner}/{repo}/compare/{target}...{source}",
    strOwner = strOwner,
    strRepo = strRepo,
    target = strTargetRef,
    source = strSourceRef,
    strGHToken = strGHToken
  )
  return(
    as.character(CompletelyFlatten(purrr::map_chr(lCompareRaw$commits, "sha")))
  )
}
