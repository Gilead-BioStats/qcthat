#' Guess relevant milestone names from the GitHub event
#'
#' Determine the name of any milestones associated with the current GitHub
#' event, if the workflow was triggered by a `"pull_request"` or `"release"`
#' event, or by a `"workflow_dispatch"` event with `"milestone"` input.
#'
#' @inheritParams shared-params
#' @returns A character vector of milestone names (if the event payload contains
#'   `pull_request$milestone$title`, `release$name`, `release$tag_name`,
#'   `inputs$milestone`, or `inputs$tag`), or `NULL` if no milestone names can
#'   be found.
#' @export
GuessMilestones <- function(lGHEventPayload = LoadGHEventPayload()) {
  if (is.list(lGHEventPayload)) {
    chrMilestones <- lGHEventPayload[["pull_request"]][["milestone"]][[
      "title"
    ]] %||%
      c(
        lGHEventPayload[["release"]][["name"]],
        lGHEventPayload[["release"]][["tag_name"]]
      ) %||%
      lGHEventPayload[["inputs"]][["milestone"]] %||%
      lGHEventPayload[["inputs"]][["tag"]]
    chrMilestones <- sort(unique(
      chrMilestones[!is.na(chrMilestones) & nzchar(chrMilestones)]
    ))
    if (length(chrMilestones)) {
      return(chrMilestones)
    }
  }
}
