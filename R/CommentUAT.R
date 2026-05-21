#' Comment on a PR or issue with a UAT report
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Add or update a comment on a GitHub pull request (or issue) with a report of
#' issues that require user acceptance, formatted in GitHub markdown. Note: This
#' should only be called *after* the test suite has ran.
#'
#' @inheritParams shared-params
#' @returns Invisibly returns the result of [CommentIssue()].
#' @family UAT functions
#' @export
CommentUAT <- function(
  intPRNumber = GuessPRNumber(
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ),
  lglUpdate = TRUE,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strJobID = Sys.getenv("GITHUB_JOB"),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token()
) {
  intIssues <- FetchPRIssueNumbers(
    intPRNumber = intPRNumber,
    strPkgRoot = strPkgRoot,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  CommentIssue(
    intPRNumber,
    strTitle = "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance",
    strBody = FormatUATGH(intIssues),
    lglUpdate = lglUpdate,
    strRunID = strRunID,
    strJobID = strJobID,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Format UAT issues in GitHub markdown
#'
#' @inheritParams shared-params
#' @returns A string containing the UAT issues formatted in GitHub markdown.
#' @keywords internal
FormatUATGH <- function(intIssues = integer()) {
  dfRelevantUAT <- dplyr::filter(
    envQcthat$UATIssues,
    .data$ParentIssue %in% intIssues | .data$Disposition != "accepted"
  )
  if (NROW(dfRelevantUAT)) {
    return(ConstructUATBody(dfRelevantUAT))
  }
  return("No issues are awaiting UAT.")
}

#' Construct the body of the UAT report comment
#'
#' @param dfRelevantUAT (`data.frame`) A data frame with columns `ParentIssue`,
#'   `UATIssue`, `Description`, `Disposition`, `Owner`, and `Repo`.
#' @returns A string containing the body of the UAT report comment, formatted in
#'   GitHub markdown.
#' @keywords internal
ConstructUATBody <- function(dfRelevantUAT) {
  lUATDFs <- split(dfRelevantUAT, dfRelevantUAT$Disposition)
  chrBody <- c(
    ConstructUATBodyPiece(
      lUATDFs[["error"]],
      "These issues had unknown processing errors during UAT checks:",
      "- UAT for #{ParentIssue}: {Description}",
      "You may want to re-run the qcthat action, or possibly edit these tests."
    ),
    ConstructUATBodyPiece(
      lUATDFs[["failed_to_create"]],
      "These issues should have UAT issues, but the child issues were not created:",
      "- UAT for #{ParentIssue}: {Description}",
      "You may want to re-run the qcthat action, or debug why the issue could not be created."
    ),
    ConstructUATBodyPiece(
      lUATDFs[["accepted"]],
      "These UAT issues have been accepted:",
      "- [x] [{Description}](https://github.com/{Owner}/{Repo}/issues/{UATIssue})"
    ),
    ConstructUATBodyPiece(
      lUATDFs[["pending"]],
      paste(
        "Click through to these issues and follow the instructions to accept them as complete",
        "(or to log additional details about changes that are needed before they can be accepted):"
      ),
      "- [ ] [{Description}](https://github.com/{Owner}/{Repo}/issues/{UATIssue})",
      "The qcthat PR-associated issues report will re-run when all of these issues are accepted."
    )
  )
  return(paste(chrBody, collapse = "\n\n\n"))
}

#' Construct the body of the UAT report comment
#'
#' @param dfIssues (`data.frame`) A data frame with columns `ParentIssue`,
#'   `UATIssue`, `Description`, `Disposition`, `Owner`, and `Repo`.
#' @param strHeader (`length-1 character`) A header to introduce the issues in
#'   this section of the report.
#' @param strBulletTemplate (`length-1 character`) A template for the bullet
#'   points describing each issue in this section of the report, with glue
#'   syntax for the relevant columns of `dfIssues`.
#' @param strFooter (`length-1 character` or `NULL`) An optional footer to
#'   conclude this section of the report.
#' @returns A string containing the body of this part of the UAT report comment,
#'   formatted in GitHub markdown.
#' @keywords internal
ConstructUATBodyPiece <- function(
  dfIssues,
  strHeader,
  strBulletTemplate,
  strFooter = NULL
) {
  if (NROW(dfIssues)) {
    lCollapse <- purrr::compact(list(
      strHeader,
      CollapseGluedData(dfIssues, strBulletTemplate),
      strFooter
    ))
    c(
      rlang::exec(
        paste,
        !!!lCollapse,
        sep = "\n\n"
      ),
      "<hr>"
    )
  }
}
