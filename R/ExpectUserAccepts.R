#' Does a user accept the feature?
#'
#' Create and track a sub-issue to track user acceptance that an issue is
#' complete.
#'
#' @inheritParams shared-params
#' @returns The input `chrChecks`, invisibly.
#' @export
ExpectUserAccepts <- function(
  chrChecks,
  intIssue,
  chrInstructions = character(),
  strFailureMode = c("ignore", "fail"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!OnCran() && UsesGit()) {
    strFailureMode <- rlang::arg_match(strFailureMode)
    lUAIssue <- FetchUAIssue(
      intIssue = intIssue,
      chrChecks = chrChecks,
      chrInstructions = chrInstructions,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    if (identical(lUAIssue[["State"]], "closed")) {
      testthat::pass()
    } else if (identical(strFailureMode, "fail")) {
      testthat::fail(c(
        "User must accept the checks and close the issue.",
        cli::format_inline("User-acceptance issue: {.url {lUAIssue[['Url']]}}")
      ))
    }
  }
  return(invisible(chrChecks))
}

#' Check whether this is being tested on CRAN
#'
#' @returns Logical indicating whether this is running on CRAN (according to
#'   testthat).
#' @keywords internal
OnCran <- function() {
  # Inspired by unexported testthat helper.
  strNotCRAN <- Sys.getenv("NOT_CRAN")
  !identical(strNotCRAN, "") && !isTRUE(as.logical(strNotCRAN))
}

#' Fetch or create a user-acceptance issue
#'
#' @inheritParams shared-params
#'
#' @returns A list representing the user-acceptance issue.
#' @keywords internal
FetchUAIssue <- function(
  intIssue,
  chrChecks,
  chrInstructions = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  # I *think* a hash of the checks is the best way to find these, but we should
  # also figure out some sort of cleanup mechanism to identify unused UAT
  # issues.
  dfMatchingIssue <- FetchIssueUAChildren(
    intIssue = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      .data$Title == paste("qcthat Acceptance:", rlang::hash(chrChecks))
    ) |>
    # If somehow multiple issues match, only use the first one.
    head(1)
  if (!NROW(dfMatchingIssue)) {
    dfMatchingIssue <- CreateUAIssue(
      intIssue = intIssue,
      chrChecks = chrChecks,
      chrInstructions = chrInstructions,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
  return(as.list(dfMatchingIssue))
}

#' Fetch all user-acceptance sub-issues for an issue
#'
#' @inheritParams shared-params
#' @returns A data frame of user-acceptance sub-issues.
#' @keywords internal
FetchIssueUAChildren <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  FetchIssueChildren(
    intIssue = intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  ) |>
    dplyr::filter(
      HaveString(.data$Labels, "qcthat-uat")
    )
}

#' Create a user-acceptance sub-issue for an issue
#'
#' @inheritParams shared-params
#' @returns A data frame representing the created user-acceptance issue.
#' @keywords internal
CreateUAIssue <- function(
  intIssue,
  chrChecks,
  chrInstructions = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strTitle <- paste("qcthat Acceptance:", rlang::hash(chrChecks))
  strBody <- paste(
    stringr::str_flatten(
      c(
        "Review the following checks and close this issue to indicate your acceptance.",
        chrInstructions
      ),
      collapse = "\n\n"
    ),
    paste("- [ ]", chrChecks, collapse = "\n"),
    sep = "\n\n"
  )
  CreateChildIssue(
    intIssue,
    strTitle,
    strBody,
    chrLabels = "qcthat-uat",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}
