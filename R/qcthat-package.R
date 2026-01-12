#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom cli qty
#' @importFrom rlang .data
## usethis namespace: end
NULL

envQcthat <- rlang::new_environment()

dfUATIssues_Empty <- tibble::tibble(
  ParentIssue = integer(),
  UATIssue = integer(),
  Description = character(),
  Disposition = character(),
  Owner = character(),
  Repo = character(),
  Timestamp = as.POSIXct(character())
)
envQcthat$UATIssues <- dfUATIssues_Empty
