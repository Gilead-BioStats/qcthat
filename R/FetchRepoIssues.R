#' Fetch repository issues
#'
#' Download (non-pull-request) issues in a repository and parse them into a tidy
#' [tibble::tibble()].
#'
#' @inheritParams shared-params
#'
#' @returns A `qcthat_Issues` object, which is a [tibble::tibble()] with
#'   columns:
#'   - `Issue`: Issue number.
#'   - `Title`: Issue title.
#'   - `Body`: Issue body (the full text of the issue).
#'   - `Labels`: List column of character vectors of issue labels.
#'   - `State`: Issue state (`open` or `closed`).
#'   - `StateReason`: Reason for issue state (e.g., `completed`) or `NA` if not
#'   applicable.
#'   - `Milestone`: Issue milestone title or `NA` if not applicable.
#'   - `Type`: Issue type or `"Issue"` if no issue type is available.
#'   - `Url`: URL of the issue on GitHub.
#'   - `ParentOwner`: GitHub username or organization name of the parent issue
#'   if applicable, otherwise `NA`.
#'   - `ParentRepo`: GitHub repository name of the parent issue if applicable,
#'   otherwise `NA`.
#'   - `ParentNumber`: GitHub issue number of the parent issue if applicable,
#'   otherwise `NA`.
#'   - `CreatedAt`: `POSIXct` timestamp of when the issue was created.
#'   - `ClosedAt`: `POSIXct` timestamp of when the issue was closed, or `NA` if
#'   the issue is still open.
#' @export
#'
#' @examplesIf interactive()
#'
#'   FetchRepoIssues()
FetchRepoIssues <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  strState = c("all", "open", "closed")
) {
  lIssuesRaw <- FetchRawRepoIssues(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = strState
  )
  lIssuesNonPR <- RemovePRsFromIssues(lIssuesRaw)
  CompileIssuesDF(lIssuesNonPR)
}

#' Fetch all repo issues from GitHub
#'
#' @inheritParams shared-params
#' @returns A list of raw issue objects as returned by [gh::gh()].
#' @keywords internal
FetchRawRepoIssues <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  strState = c("all", "open", "closed")
) {
  strState <- match.arg(strState)
  CallGHAPI(
    strEndpoint = "GET /repos/{owner}/{repo}/issues",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    state = strState
  )
}

#' Wrapper around gh::gh() for mocking
#'
#' @param strEndpoint (`length-1 character`) The endpoint to call, e.g., `"GET
#'   /repos/{owner}/{repo}/issues"`.
#' @param numLimit (`length-1 numeric`) Maximum number of results to return.
#'   Default is `Inf` (no limit).
#' @param ... Additional parameters passed to [gh::gh()].
#' @inheritParams shared-params
#' @returns The result of the [gh::gh()] call.
#' @keywords internal
CallGHAPI <- function(
  strEndpoint,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  numLimit = Inf,
  ...
) {
  # Tested manually.

  # nocov start
  gh::gh(
    strEndpoint,
    owner = strOwner,
    repo = strRepo,
    .token = strGHToken,
    .limit = numLimit,
    ...
  )
  # nocov end
}

#' Get rid of PRs in the issues list
#'
#' @param lIssuesRaw (`list`) List of raw issue objects as returned by
#'   [gh::gh()].
#' @returns A list of issue objects without PRs.
#' @keywords internal
RemovePRsFromIssues <- function(lIssuesRaw) {
  purrr::keep(
    lIssuesRaw,
    function(lIssue) is.null(lIssue[["pull_request"]])
  )
}

#' Compile issues data frame
#'
#' @inherit FetchRepoIssues return
#' @keywords internal
CompileIssuesDF <- function(lIssuesNonPR) {
  if (!length(lIssuesNonPR)) {
    return(AsIssuesDF(EmptyIssuesDF()))
  }
  EnframeIssues(lIssuesNonPR) |>
    dplyr::mutate(
      Labels = ExtractLabels(.data$Labels),
      Milestone = ExtractName(.data$Milestone, "title"),
      Type = dplyr::coalesce(ExtractName(.data$Type, "name"), "Issue"),
      CreatedAt = as.POSIXct(.data$CreatedAt, tz = "UTC"),
      ClosedAt = as.POSIXct(.data$ClosedAt, tz = "UTC")
    ) |>
    SeparateParentColumn() |>
    AsIssuesDF()
}

#' Assign the qcthat_Issues class to a data frame
#'
#' @inheritParams AsExpected
#' @returns A `qcthat_Issues` object.
#' @keywords internal
AsIssuesDF <- function(x) {
  AsExpected(
    x,
    EmptyIssuesDF(),
    chrClass = "qcthat_Issues"
  )
}

#' Empty issues data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyIssuesDF <- function() {
  tibble::tibble(
    Issue = integer(0),
    Title = character(0),
    Body = character(0),
    Labels = list(),
    State = character(0),
    StateReason = character(0),
    Milestone = character(0),
    Type = character(0),
    Url = character(0),
    ParentOwner = character(0),
    ParentRepo = character(0),
    ParentNumber = integer(0),
    CreatedAt = as.POSIXct(character(0)),
    ClosedAt = as.POSIXct(character(0))
  )
}

#' Transform issues list into tibble with expected columns
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with raw issue data.
#' @keywords internal
EnframeIssues <- function(lIssuesNonPR) {
  dfIssues <- tibble::enframe(lIssuesNonPR, name = NULL) |>
    tidyr::unnest_wider("value") |>
    dplyr::select(
      dplyr::any_of(c(
        Issue = "number",
        Title = "title",
        Body = "body",
        Labels = "labels",
        State = "state",
        StateReason = "state_reason",
        Milestone = "milestone",
        Type = "type",
        Url = "html_url",
        ParentUrl = "parent_issue_url",
        CreatedAt = "created_at",
        ClosedAt = "closed_at"
      ))
    )

  # Bind to the "standard" empty to ensure all columns are present.
  dplyr::bind_rows(
    EmptyIssuesDFRaw(),
    dfIssues
  )
}

#' Empty issues data frame (raw)
#'
#' @returns A standard [tibble::tibble()] with the correct columns (before
#'   transformations) but no rows.
#' @keywords internal
EmptyIssuesDFRaw <- function() {
  tibble::tibble(
    Issue = integer(0),
    Title = character(0),
    Body = character(0),
    Labels = list(),
    State = character(0),
    StateReason = character(0),
    Milestone = list(),
    Type = list(),
    Url = character(0),
    ParentUrl = character(0),
    CreatedAt = character(0),
    ClosedAt = character(0)
  )
}

#' Extract label names from label objects
#'
#' @param lLabels (`list`) List column of label objects as returned by GitHub
#'   API.
#'
#' @returns A list column of character vectors of label names.
#' @keywords internal
ExtractLabels <- function(lLabels) {
  purrr::map(lLabels, function(lLabelSet) {
    chrExtractedLabels <- purrr::map_chr(lLabelSet, "name")
    return(NullIfEmpty(chrExtractedLabels))
  })
}

#' Extract label names from label objects
#'
#' @param lColumn (`list`) A list column of objects.
#' @param strName (`length-1 character`) Name of the field to extract from each
#'   object.
#' @returns A character vector of the target field from each object, or `NA` if
#'   the field is missing from a given element of the list.
#' @keywords internal
ExtractName <- function(lColumn, strName) {
  purrr::map_chr(
    lColumn,
    function(lObject) {
      lObject[[strName]] %||% NA_character_
    }
  )
}

#' Parse the ParentUrl column into its components
#'
#' @param dfIssues (`data.frame`) Data frame with a `ParentUrl` column.
#' @returns The input data frame with `ParentUrl` split into `ParentOwner`,
#'   `ParentRepo`, and `ParentNumber` columns.
#' @keywords internal
SeparateParentColumn <- function(dfIssues) {
  dfIssues <- tidyr::separate_wider_regex(
    dfIssues,
    "ParentUrl",
    patterns = c(
      "^https://api.github.com/repos/",
      ParentOwner = "[^/]+",
      "/",
      ParentRepo = "[^/]+",
      "/issues/",
      ParentNumber = "\\d+$"
    )
  )
  dfIssues$ParentNumber <- as.integer(dfIssues$ParentNumber)
  return(dfIssues)
}
