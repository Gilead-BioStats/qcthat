#' Load the GitHub event payload
#'
#' @param strGHEventPath (`length-1 character`) Path to the GitHub event
#'   payload JSON file. Defaults to the `GITHUB_EVENT_PATH` environment
#'   variable.
#' @returns A list containing the parsed JSON payload, or `NULL` if
#'   `strGHEventPath` is empty.
#' @keywords internal
LoadGHEventPayload <- function(
  strGHEventPath = Sys.getenv("GITHUB_EVENT_PATH")
) {
  if (nzchar(strGHEventPath)) {
    return(jsonlite::read_json(strGHEventPath))
  }
  return(NULL)
}
