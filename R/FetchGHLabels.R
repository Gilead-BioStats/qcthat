#' Fetch GitHub labels as a data frame
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Label`: Label name.
#'   - `Description`: Label description.
#'   - `Color`: Label color as a hex code (e.g., `"#444444"`).
#' @keywords internal
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

#' Fetch GitHub labels as raw list
#'
#' @inheritParams shared-params
#' @returns A list of label objects as returned by [gh::gh()].
#' @keywords internal
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

#' Create an empty labels data frame
#'
#' @returns A 0-row [tibble::tibble()] with columns `Label`, `Description`, and
#'   `Color`.
#' @keywords internal
EmptyLabelsDF <- function() {
  tibble::tibble(
    Label = character(),
    Description = character(),
    Color = character()
  )
}

#' Convert raw GitHub labels list to data frame
#'
#' @param lGHLabels (`list`) List of label objects as returned by [gh::gh()].
#' @returns A [tibble::tibble()] with columns `Label`, `Description`, and
#'   `Color`, or `NULL` if `lGHLabels` is empty.
#' @keywords internal
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

