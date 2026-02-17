#' Create a GitHub label
#'
#' @inheritParams shared-params
#' @returns The raw label object as returned by [gh::gh()] (invisibly).
#' @keywords internal
CreateGHLabel <- function(
  strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglUpdate = TRUE,
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfExistingLabels <- FetchGHLabels(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (strLabel %in% dfExistingLabels$Label) {
    return(
      MaybeUpdateGHLabel(
        strLabel = strLabel,
        strLabelDescription = strLabelDescription,
        strLabelColor = strLabelColor,
        lglUpdate = lglUpdate,
        lglVerbose = lglVerbose,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    )
  }
  CreateGHLabelImpl(
    strLabel = strLabel,
    strLabelDescription = strLabelDescription,
    strLabelColor = strLabelColor,
    lglVerbose = lglVerbose,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Maybe update an existsing GitHub label
#'
#' @inheritParams shared-params
#' @returns The raw label object as returned by [gh::gh()] (invisibly).
#' @keywords internal
MaybeUpdateGHLabel <- function(
  strLabel,
  strLabelNewName = strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglUpdate = TRUE,
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (lglUpdate) {
    return(
      UpdateGHLabel(
        strLabel = strLabel,
        strLabelNewName = strLabelNewName,
        strLabelDescription = strLabelDescription,
        strLabelColor = strLabelColor,
        lglVerbose = lglVerbose,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    )
  }
  qcthatAbort(
    "Label {strLabel} already exists.",
    strErrorSubclass = "label_exists"
  )
}

#' Update a GitHub label
#'
#' @inheritParams shared-params
#' @returns The raw label object as returned by [gh::gh()] (invisibly).
#' @keywords internal
UpdateGHLabel <- function(
  strLabel,
  strLabelNewName = strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lGHAPIReturn <- CallGHAPI(
    "PATCH /repos/{owner}/{repo}/labels/{name}",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    name = strLabel,
    new_name = strLabelNewName,
    color = stringr::str_remove(strLabelColor, "#"),
    description = strLabelDescription
  )
  if (identical(lGHAPIReturn[["name"]], strLabel)) {
    if (lglVerbose) {
      cli::cli_inform(
        "Label {.val {strLabel}} was updated (if necessary).",
        class = CompileConditionClasses("update_label", "message")
      )
    }
    return(invisible(lGHAPIReturn))
  }
  qcthatAbort(
    "Failed to update label {.val {strLabel}}.",
    strErrorSubclass = "update_label"
  )
}

#' Create a GitHub label (implementation)
#'
#' @inheritParams shared-params
#' @returns The raw label object as returned by [gh::gh()] (invisibly).
#' @keywords internal
CreateGHLabelImpl <- function(
  strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
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
        class = CompileConditionClasses("create_label", "message")
      )
    }
    return(invisible(lGHAPIReturn))
  }
  qcthatAbort(
    "Failed to create label {.val {strLabel}}.",
    strErrorSubclass = "create_label"
  )
}
