FetchGHLabels <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lGHLabels <- FetchGHLabelsRaw(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  purrr::list_rbind(list(
    EmptyLabelsDF(),
    EnframeGHLabels(lGHLabels)
  ))
}

FetchGHLabelsRaw <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "GET /repos/{owner}/{repo}/labels",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

EmptyLabelsDF <- function() {
  tibble::tibble(
    Label = character(),
    Description = character(),
    Color = character()
  )
}

EnframeGHLabels <- function(lGHLabels) {
  if (length(lGHLabels)) {
    tibble::as_tibble_col(lGHLabels) |>
      tidyr::unnest_wider("value") |>
      dplyr::select(
        Label = "name",
        Description = "description",
        Color = "color"
      ) |>
      dplyr::mutate(Color = paste0("#", .data$Color))
  }
}

#' Fetch existing GitHub label names
#'
#' @inheritParams shared-params
#' @returns A character vector of existing label names in the specified GitHub
#'   repository.
#' @keywords internal
FetchGHLabelNames <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lExistingLabels <- FetchGHLabelsRaw(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  purrr::map_chr(lExistingLabels, "name")
}
