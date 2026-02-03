#' Save UAT issues to disk
#'
#' Save the internal registry of user acceptance testing (UAT) issues to an RDS
#' file. This allows the UAT state to be persisted across R sessions.
#'
#' @param strPath (`length-1 character`) Path to the UAT file. Defaults to
#'   `"UATIssues.rds"` in the working directory.
#'
#' @returns `NULL` invisibly.
#' @export
SaveUATIssues <- function(strPath = "UATIssues.rds") {
  saveRDS(envQcthat$UATIssues, strPath)
}

#' Load UAT issues from disk
#'
#' Load a registry of user acceptance testing (UAT) issues from an RDS file into
#' the internal package environment.
#'
#' @inheritParams SaveUATIssues
#'
#' @returns The UAT issues data frame.
#' @export
LoadUATIssues <- function(strPath = "UATIssues.rds") {
  envQcthat$UATIssues <- readRDS(strPath)
}
