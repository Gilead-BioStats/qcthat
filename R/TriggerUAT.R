#' Trigger the UAT cycle for closed issues
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Identify pull requests that mention a closed issue, and potentially
#' re-trigger the UAT cycle. If all issues referenced in the UAT comment of a
#' linked PR are closed (and it is not already running the QCPR workflow), rerun
#' the QCPR workflow (`qcthat.yaml`) if available.
#'
#' @param intClosedIssue (`length-1 integer`) A closed UAT issue number.
#' @inheritParams shared-params
#'
#' @returns A `data.frame` of PRs that referenced the issue (invisibly). This
#'   function is called for its side effects.
#'
#' @family UAT functions
#' @export
TriggerUAT <- function(
  intClosedIssue = GuessIssueNumber(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfOpenPRRefs <- FetchAllIssuePRRefs(
    intClosedIssue,
    strPRState = "open",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (NROW(dfOpenPRRefs)) {
    MaybeRerunAllQCPRWorkflows(
      dfOpenPRRefs = dfOpenPRRefs,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
}

#' Rerun QCPR workflows for PRs if UAT conditions are met
#'
#' @param dfOpenPRRefs (`data.frame`) A tibble of PR references, as returned by
#'   `FetchAllIssuePRRefs()`. Must contain columns `PR`, `HeadRef`, and `SHA`.
#' @inheritParams shared-params
#' @returns `dfOpenPRRefs` (invisibly). Called for side effects.
#' @keywords internal
MaybeRerunAllQCPRWorkflows <- function(
  dfOpenPRRefs,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  # We fetch closed issues once. Note that means it's *possible* for things to
  # become closed while this executes, but, in that case, the later issue
  # closing will re-trigger this function, and make the process valid.
  intAllClosedIssues <- FetchRepoIssues(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = "closed"
  )

  purrr::pwalk(dfOpenPRRefs, function(PR, HeadRef, SHA, ...) {
    intUATIssues <- FetchPRUATCommentIssues(
      PR,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
    if (
      length(intUATIssues) && all(intUATIssues %in% intAllClosedIssues$Issue)
    ) {
      MaybeRerunQCPRWorkflow(
        intPRNumber = PR,
        strPRHeadRef = HeadRef,
        strCommitSHA = SHA,
        strOwner = strOwner,
        strRepo = strRepo,
        strGHToken = strGHToken
      )
    }
  })
}

#' Extract issue numbers from a PR's UAT comment
#'
#' @inheritParams shared-params
#' @returns A sorted integer vector of unique issue numbers found in the UAT
#'   comment. Returns `NULL` invisibly if no comment or no issues are found.
#' @keywords internal
FetchPRUATCommentIssues <- function(
  intPRNumber,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  dfComments <- FetchIssueComments(intPRNumber) |>
    dplyr::filter(
      .data$qcthatCommentID ==
        rlang::hash(
          "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance"
        )
    )
  if (NROW(dfComments) && nzchar(dfComments$Body[[1]])) {
    stringr::str_split_1(dfComments$Body[[1]], "\n") |>
      stringr::str_subset("https://github.com") |>
      stringr::str_extract(
        "https://github.com/[^/]+/[^/]+/issues/([0-9]+)",
        group = 1
      ) |>
      as.integer() |>
      unique() |>
      sort()
  }
}

#' Rerun the QCPR workflow for a specific PR and commit
#'
#' @inheritParams shared-params
#' @returns `NULL` (invisibly). Called for side effects.
#' @keywords internal
MaybeRerunQCPRWorkflow <- function(
  intPRNumber,
  strPRHeadRef,
  strCommitSHA,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lPRQCPRReportRuns <- FetchPRActionRuns(
    strPRHeadRef = strPRHeadRef,
    strAction = "qcthat",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  if (length(lPRQCPRReportRuns)) {
    RerunWorkflowIfFinished(
      lPRActionRuns = lPRQCPRReportRuns,
      strCommitSHA = strCommitSHA,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
}

#' Fetch workflow runs for a PR
#'
#' @param strAction (`length-1 character`) Optional string to filter workflow
#'   paths (e.g., "qcthat").
#' @inheritParams shared-params
#' @returns A list of workflow run objects returned by [CallGHAPI()].
#' @keywords internal
FetchPRActionRuns <- function(
  strPRHeadRef,
  strAction = character(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lPRActionRuns <- CallGHAPI(
    "GET /repos/{owner}/{repo}/actions/runs",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    branch = strPRHeadRef
  )
  lPRActionWorkflows <- lPRActionRuns$workflow_runs

  if (length(strAction)) {
    lPRActionWorkflows <- purrr::keep(
      lPRActionWorkflows,
      function(lRun) {
        stringr::str_detect(lRun$path, strAction)
      }
    )
  }
  return(lPRActionWorkflows)
}

#' Rerun a workflow only if no instances are currently in progress
#'
#' @inheritParams shared-params
#' @returns `NULL` (invisibly). Called for side effects.
#' @keywords internal
RerunWorkflowIfFinished <- function(
  lPRActionRuns,
  strCommitSHA,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lglIsInProgress <- purrr::map_lgl(
    lPRActionRuns,
    function(lRun) {
      stringr::str_detect(lRun$status, "in_progress")
    }
  )

  if (!any(lglIsInProgress)) {
    RerunWorkflowAtSHA(
      lPRActionRuns = lPRActionRuns,
      strCommitSHA = strCommitSHA,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
}

#' Identify and rerun the specific workflow run for a commit SHA
#'
#' @inheritParams shared-params
#' @returns `NULL` (invisibly). Called for side effects.
#' @keywords internal
RerunWorkflowAtSHA <- function(
  lPRActionRuns,
  strCommitSHA,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lActionToRerun <- purrr::detect(lPRActionRuns, function(lRun) {
    lRun$head_sha == strCommitSHA
  })
  if (length(lActionToRerun)) {
    RerunWorkflow(
      strRunID = lActionToRerun$id,
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  }
}

#' Trigger a rerun of a GitHub Action workflow run
#'
#' @param strRunID (`length-1 character, double, or integer`) The ID of the
#'   workflow run to rerun.
#' @inheritParams shared-params
#' @returns An empty GitHub API return with status code 201.
#' @keywords internal
RerunWorkflow <- function(
  strRunID,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  CallGHAPI(
    "POST /repos/{owner}/{repo}/actions/runs/{run_id}/rerun",
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    run_id = strRunID
  )
}
