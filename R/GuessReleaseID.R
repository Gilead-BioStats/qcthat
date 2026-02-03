#' Guess the relevant release id from the GitHub event
#'
#' Determine the release id associated with the current GitHub event, if the
#' workflow was triggered by a `"release"` event, or by a `"workflow_dispatch"`
#' event with `"tag"` input
#'
#' @inheritParams shared-params
#' @returns A string or number representing the release id (if the event payload
#'   contains `release$id`, `release$tag_name`, or `inputs$tag`), or `NULL` if
#'   the event is not a `"release"` event or the release id cannot be found.
#' @export
GuessReleaseID <- function(
  lGHEventPayload = LoadGHEventPayload(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (is.list(lGHEventPayload)) {
    strReleaseID <- lGHEventPayload$release$id
    if (!length(strReleaseID)) {
      strTagName <- lGHEventPayload$release$tag_name %||%
        lGHEventPayload$inputs$tag
      if (length(strTagName)) {
        lRelease <- FetchRawReleaseByTagName(
          strTagName = strTagName,
          strOwner = strOwner,
          strRepo = strRepo,
          strGHToken = strGHToken
        )
        strReleaseID <- lRelease$id
      }
    }
    return(strReleaseID)
  }
}

#' Fetch a release from GitHub
#'
#' @inheritParams shared-params
#' @returns A raw release object as a list as returned by [gh::gh()].
#' @keywords internal
FetchRawReleaseByTagName <- function(
  strTagName,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "GET /repos/{owner}/{repo}/releases/tags/{tag}",
    tag = strTagName,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}
