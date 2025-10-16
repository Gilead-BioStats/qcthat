FetchRepoIssues <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lIssuesRaw <- .FetchRawRepoIssues(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  lIssuesNonPR <- .RemovePRsFromIssues(lIssuesRaw)
  .CompileIssuesDF(lIssuesNonPR)
}

.FetchRawRepoIssues <- function(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  # Tested manually.

  # nocov start
  gh::gh(
    "GET /repos/{owner}/{repo}/issues",
    owner = strOwner,
    repo = strRepo,
    state = "all",
    .token = strGHToken
  )
  # nocov end
}

.RemovePRsFromIssues <- function(lIssuesRaw) {
  purrr::keep(
    lIssuesRaw,
    function(lIssue) is.null(lIssue[["pull_request"]])
  )
}

.CompileIssuesDF <- function(lIssuesNonPR) {
  if (!length(lIssuesNonPR)) {
    return(.EmptyIssuesDF())
  }
  .EnframeIssues(lIssuesNonPR) |>
    dplyr::mutate(
      Labels = .ExtractLabels(.data$Labels),
      Milestone = .ExtractName(.data$Milestone, "title"),
      Type = .ExtractName(.data$Type, "name"),
      CreatedAt = as.POSIXct(.data$CreatedAt, tz = "UTC"),
      ClosedAt = as.POSIXct(.data$ClosedAt, tz = "UTC")
    ) |>
    .SeparateParentColumn()
}

.EmptyIssuesDF <- function() {
  tibble::tibble(
    Number = integer(0),
    Title = character(0),
    Labels = list(),
    Status = character(0),
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

.EnframeIssues <- function(lIssuesNonPR) {
  dfIssues <- tibble::enframe(lIssuesNonPR, name = NULL) |>
    tidyr::unnest_wider("value") |>
    dplyr::select(
      dplyr::any_of(c(
        Number = "number",
        Title = "title",
        Labels = "labels",
        Status = "state",
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
    .EmptyIssuesDFRaw(),
    dfIssues
  )
}

.EmptyIssuesDFRaw <- function() {
  tibble::tibble(
    Number = integer(0),
    Title = character(0),
    Labels = list(),
    Status = character(0),
    StateReason = character(0),
    Milestone = list(),
    Type = list(),
    Url = character(0),
    ParentUrl = character(0),
    CreatedAt = as.POSIXct(character(0)),
    ClosedAt = as.POSIXct(character(0))
  )
}

.ExtractLabels <- function(lLabels) {
  purrr::map(lLabels, function(lLabelSet) {
    chrExtractedLabels <- purrr::map_chr(lLabelSet, "name")
    return(.NullIfEmpty(chrExtractedLabels))
  })
}

.ExtractName <- function(lColumn, strName) {
  purrr::map_chr(
    lColumn,
    function(lObject) {
      lObject[[strName]] %||% NA_character_
    }
  )
}

.NullIfEmpty <- function(x) {
  if (!length(x)) {
    return(NULL)
  }
  return(x)
}

.SeparateParentColumn <- function(dfIssues) {
  tidyr::separate_wider_regex(
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
}
