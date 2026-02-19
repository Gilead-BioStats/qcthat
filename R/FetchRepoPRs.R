#' Fetch repository pull requests
#'
#' Download pull requests in a repository and parse them into a tidy
#' [tibble::tibble()].
#'
#' @inheritParams shared-params
#' @returns A `qcthat_PRs` object, which is a [tibble::tibble()] with
#'   columns:
#'   - `PR`: Pull request number.
#'   - `Title`: Pull request title.
#'   - `State`: Pull request state (`"open"` or `"closed"`).
#'   - `HeadRef`: The head reference (branch) of the pull request (the changes).
#'   - `BaseRef`: The base reference (branch) of the pull request (the target).
#'   - `Body`: The full text of the pull request.
#'   - `MergeCommitSHA`: The SHA of the merge commit, if the pull request has been
#'   merged.
#'   - `IsDraft`: Logical indicating whether the pull request is a draft.
#'   - `Url`: URL of the pull request on GitHub.
#'   - `CreatedAt`: `POSIXct` timestamp of when the pull request was created.
#'   - `ClosedAt`: `POSIXct` timestamp of when the pull request was closed, or
#'   `NA` if the pull request is still open.
#'   - `MergedAt`: `POSIXct` timestamp of when the pull request was merged, or
#'   `NA` if the pull request has not been merged.
#' @export
#' @examplesIf interactive()
#'
#'   FetchRepoPRs()
FetchRepoPRs <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
) {
  strState <- match.arg(strState)
  lPRs <- FetchRawRepoPRs(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken,
    strState = strState
  )
  CompilePRDF(lPRs)
}

#' Fetch repo PRs from GitHub
#'
#' @inheritParams shared-params
#' @returns A list of raw pull request objects as returned by [gh::gh()].
#' @keywords internal
FetchRawRepoPRs <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
) {
  strState <- match.arg(strState)
  CallGHAPI(
    "GET /repos/{owner}/{repo}/pulls",
    state = strState,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Fetch a single repo PR from GitHub
#'
#' @inheritParams shared-params
#' @returns A list representing a raw pull request object as returned by
#'   [gh::gh()].
#' @keywords internal
FetchRawRepoPRSingle <- function(
  intPRNumber = GuessPRNumber(".", strOwner, strRepo, strGHToken),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
) {
  # nocov start
  tryCatch(
    CallGHAPI(
      "GET /repos/{owner}/{repo}/pulls/{pull_number}",
      strOwner = strOwner,
      strRepo = strRepo,
      pull_number = intPRNumber,
      strGHToken = strGHToken
    ),
    error = function(e) {
      qcthatAbort(
        c(
          "{.arg intPRNumber} must refer to a pull request in the specified repository.",
          i = "Pull request number {.val {intPRNumber}} not found in repository {.val {strOwner}/{strRepo}}."
        ),
        strErrorSubclass = "pr_not_found",
        envCall = envCall
      )
    }
  )
  # nocov end
}

#' Look up a PR from a list by number
#'
#' @param lPRs A list of raw pull request objects as returned by
#'   [FetchRawRepoPRs()].
#' @param intPRNumber (`length-1 integer`) The pull request number to look up.
#' @param envCall (`environment`) The calling environment for error messages.
#' @returns A list representing a raw pull request object.
#' @keywords internal
LookupPRFromList <- function(lPRs, intPRNumber, envCall = rlang::caller_env()) {
  if (rlang::is_named(lPRs)) {
    lPR <- list(lPRs[[as.character(intPRNumber)]])
  } else {
    lPR <- purrr::keep(lPRs, \(x) isTRUE(x$number == intPRNumber))
  }
  if (length(lPR)) {
    return(lPR[[1]])
  }
  qcthatAbort(
    c(
      "{.arg intPRNumber} must refer to a pull request in the provided list.",
      i = "Pull request number {.val {intPRNumber}} not found."
    ),
    strErrorSubclass = "pr_not_found",
    envCall = envCall
  )
}

#' Compile pull requests data frame
#'
#' @inherit FetchRepoIssues return
#' @keywords internal
CompilePRDF <- function(lPRs) {
  if (!length(lPRs)) {
    return(AsPRsDF(EmptyPRsDF()))
  }
  EnframePRs(lPRs) |>
    dplyr::mutate(
      HeadRef = ExtractName(.data$HeadRef, "ref"),
      BaseRef = ExtractName(.data$BaseRef, "ref"),
      CreatedAt = as.POSIXct(.data$CreatedAt, tz = "UTC"),
      ClosedAt = as.POSIXct(.data$ClosedAt, tz = "UTC"),
      MergedAt = as.POSIXct(.data$MergedAt, tz = "UTC")
    ) |>
    AsPRsDF()
}

#' Transform PR list into tibble with expected columns
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with raw PR data.
#' @keywords internal
EnframePRs <- function(lPRs) {
  dfPRs <- tibble::enframe(lPRs, name = NULL) |>
    tidyr::unnest_wider("value") |>
    dplyr::select(
      dplyr::any_of(c(
        PR = "number",
        Title = "title",
        State = "state",
        HeadRef = "head",
        BaseRef = "base",
        Body = "body",
        MergeCommitSHA = "merge_commit_sha",
        IsDraft = "draft",
        Url = "html_url",
        CreatedAt = "created_at",
        ClosedAt = "closed_at",
        MergedAt = "merged_at"
      ))
    )

  # Bind to the "standard" empty to ensure all columns are present.
  dplyr::bind_rows(
    EmptyPRsDFRaw(),
    dfPRs
  )
}

#' Empty PR data frame
#'
#' @returns A standard [tibble::tibble()] with the correct columns but no rows.
#' @keywords internal
EmptyPRsDF <- function() {
  tibble::tibble(
    PR = integer(),
    Title = character(),
    State = character(),
    HeadRef = character(),
    BaseRef = character(),
    Body = character(),
    MergeCommitSHA = character(),
    IsDraft = logical(),
    Url = character(),
    CreatedAt = as.POSIXct(character()),
    ClosedAt = as.POSIXct(character()),
    MergedAt = as.POSIXct(character())
  )
}

#' Empty PR data frame (raw)
#'
#' @returns A standard [tibble::tibble()] with the correct columns (before
#'   transformations) but no rows.
#' @keywords internal
EmptyPRsDFRaw <- function() {
  tibble::tibble(
    PR = integer(),
    Title = character(),
    State = character(),
    HeadRef = vctrs::list_of(.ptype = character()),
    BaseRef = vctrs::list_of(.ptype = character()),
    Body = character(),
    MergeCommitSHA = character(),
    IsDraft = logical(),
    Url = character(),
    CreatedAt = character(),
    ClosedAt = character(),
    MergedAt = character()
  )
}

#' Assign the qcthat_PRs class to a data frame
#'
#' @inheritParams AsExpected
#' @returns A `qcthat_PRs` object.
#' @keywords internal
AsPRsDF <- function(x) {
  AsExpected(
    x,
    EmptyPRsDF(),
    chrClass = "qcthat_PRs"
  )
}
