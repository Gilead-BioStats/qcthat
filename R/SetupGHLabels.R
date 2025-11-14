#' Default labels to ignore
#'
#' Returns the character vector of issue labels that are ignored by default in
#' QC reports. Currently, this list only includes `"qcthat-nocov"`, but it may
#' change as we add more standard labels.
#'
#' @returns A character vector of label names.
#' @export
#'
#' @examples
#' DefaultIgnoreLabels()
DefaultIgnoreLabels <- function() {
  "qcthat-nocov"
}

#' Default descriptions for ignored labels
#'
#' Returns the character vector of descriptions corresponding to the labels
#' returned by [DefaultIgnoreLabels()].
#'
#' @returns A character vector of label descriptions.
#' @keywords internal
DefaultIgnoreLabelDescriptions <- function() {
  "Do not include in issue-test coverage reports"
}

#' Default ignored labels as a tibble
#'
#' Returns a tibble of ignore labels (from [DefaultIgnoreLabels()]), their
#' descriptions, and the colors of their labels.
#'
#' @returns A [tibble::tibble()] with columns `Label`, `Description`, and
#'   `Color`.
#' @export
#' @examples
#' DefaultIgnoreLabelsDF()
DefaultIgnoreLabelsDF <- function() {
  tibble::tibble(
    Label = DefaultIgnoreLabels(),
    Description = DefaultIgnoreLabelDescriptions(),
    Color = "#444444"
  )
}

#' Setup qcthat labels in a GitHub repository
#'
#' Create the qcthat labels in a GitHub repository if those labels do not
#' already exist.
#'
#' @param dfLabels (`data.frame`) A data frame with columns `Label`,
#'   `Description`, and `Color`, specifying the labels to create. By default,
#'   this is the data frame returned by [DefaultIgnoreLabelsDF()]. Descriptions
#'   of labels created via this function are prefixed with `"{qcthat}: "` to
#'   make it easier to search for them in your list of labels.
#' @inheritParams shared-params
#' @returns `NULL` (invisibly).
#' @export
SetupGHLabels <- function(
  dfLabels = DefaultIgnoreLabelsDF(),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  dfLabels <- PrepareDFLabels(dfLabels, strOwner, strRepo, strGHToken)
  lLabelInfo <- purrr::pmap(
    dfLabels,
    function(Label, Description, Color) {
      CreateGHLabel(
        strLabel = Label,
        strLabelDescription = Description,
        strLabelColor = Color,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    }
  )
  return(invisible(lLabelInfo))
}

#' Fetch existing GitHub labels
#'
#' @inheritParams shared-params
#' @returns A character vector of existing label names in the specified GitHub
#'   repository.
#' @keywords internal
FetchGHLabels <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lExistingLabels <- CallGHAPI(
    "GET /repos/{owner}/{repo}/labels",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  purrr::map_chr(lExistingLabels, "name")
}

#' Prepare the data frame of labels to create
#'
#' @inheritParams SetupGHLabels
#' @returns A validated data frame of labels to create.
#' @keywords internal
PrepareDFLabels <- function(
  dfLabels,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  ValidateDFLabels(dfLabels)
  chrGHLabels <- FetchGHLabels(strOwner, strRepo, strGHToken)
  dfLabels <- dfLabels |>
    dplyr::filter(
      !NormalizeLabelPrefix(.data$Label) %in% NormalizeLabelPrefix(chrGHLabels)
    ) |>
    dplyr::mutate(
      Label = NormalizeLabelPrefix(.data$Label),
      Description = NormalizeDescriptionPrefix(.data$Description)
    )
  return(dfLabels)
}

#' Validate the labels data frame
#'
#' @inheritParams SetupGHLabels
#' @returns `NULL` (invisibly). Errors if the data frame is invalid.
#' @keywords internal
ValidateDFLabels <- function(dfLabels) {
  missingCols <- setdiff(c("Label", "Description", "Color"), colnames(dfLabels))
  if (length(missingCols)) {
    cli::cli_abort(
      c(
        "The labels data frame is missing required columns: ",
        i = "{.val {missingCols}}"
      ),
      class = "qcthat-error-invalid_dfLabels"
    )
  }
}

#' Normalize the label prefix
#'
#' @inheritParams CreateGHLabel
#' @returns The label with the prefix `"qcthat-"`.
#' @keywords internal
NormalizeLabelPrefix <- function(strLabel) {
  paste0("qcthat-", stringr::str_remove(strLabel, "^qcthat-"))
}

#' Normalize the label description prefix
#'
#' @inheritParams CreateGHLabel
#' @returns The label description with the prefix `"{qcthat}: "`.
#' @keywords internal
NormalizeDescriptionPrefix <- function(strLabelDescription) {
  paste(
    "{qcthat}:",
    stringr::str_remove(strLabelDescription, "^\\{qcthat\\}: ")
  )
}

#' Create a GitHub label
#'
#' @inheritParams shared-params
#' @param strLabel (`length-1 character`) The name of the label to create.
#' @param strLabelColor (`length-1 character`) The hex color code for the
#'   label (e.g., `"#444444"`).
#' @param strLabelDescription (`length-1 character`) The description for the
#'   label.
#' @returns The raw label object as returned by [gh::gh()] (invisibly).
#' @keywords internal
CreateGHLabel <- function(
  strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lGHAPIReturn <- CallGHAPI(
    "POST /repos/{owner}/{repo}/labels",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    name = strLabel,
    color = stringr::str_remove(strLabelColor, "#"),
    description = strLabelDescription
  )
  if (identical(lGHAPIReturn[["name"]], strLabel)) {
    if (lglVerbose) {
      cli::cli_inform(
        "Created label {.val {strLabel}}.",
        class = "qcthat-message-create_label"
      )
    }
    return(invisible(lGHAPIReturn))
  }
  cli::cli_abort(
    "Failed to create label {.val {strLabel}}.",
    class = "qcthat-error-create_label"
  )
}
