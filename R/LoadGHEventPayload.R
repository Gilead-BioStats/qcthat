#' Load the GitHub event payload
#'
#' Read the JSON file located at `GITHUB_EVENT_PATH` and confirm that it
#' resembles a GitHub event payload.
#'
#' @param strGHEventPath (`length-1 character`) Path to the GitHub event payload
#'   JSON file. Defaults to the `GITHUB_EVENT_PATH` environment variable.
#'
#' @returns A list containing the parsed JSON payload, or `NULL` if
#'   `strGHEventPath` is empty or does not point to a GitHub event payload.
#' @export
LoadGHEventPayload <- function(
  strGHEventPath = Sys.getenv("GITHUB_EVENT_PATH")
) {
  if (
    length(strGHEventPath) == 1 &&
      nzchar(strGHEventPath) &&
      fs::file_exists(strGHEventPath)
  ) {
    lPayload <- jsonlite::read_json(strGHEventPath)
    if (
      is.list(lPayload) &&
        length(lPayload) &&
        (length(lPayload$action) ||
          length(lPayload$inputs) ||
          length(lPayload$sender) ||
          length(lPayload$repository))
    ) {
      return(lPayload)
    }
  }
}
