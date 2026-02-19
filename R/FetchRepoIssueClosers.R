#' Fetch repository issue closers
#'
#' Fetch the closers (commits or pull requests) for all closed issues in a
#' repository.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number.
#'   - `CloserType`: Type of the closer, either `Commit` or `PullRequest`.
#'   - `CloserSHA`: SHA of the commit that closed the issue, or `NA` if the
#'   issue was closed by a pull request.
#'   - `CloserPRNumber`: Number of the pull request that closed the issue, or
#'   `NA` if the issue was closed by a commit.
#' @export
#' @examplesIf interactive()
#'
#'   FetchRepoIssueClosers()
FetchRepoIssueClosers <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lIssueClosers <- FetchRepoIssueClosersRaw(
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  c(
    list(tibble::tibble(
      Issue = integer(),
      CloserType = character(),
      CloserSHA = character(),
      CloserPRNumber = integer()
    )),
    purrr::map(lIssueClosers, TibblifyIssueCloser)
  ) |>
    purrr::list_rbind() |>
    dplyr::arrange(.data$Issue) |>
    dplyr::distinct()
}

#' Fetch raw repository issue closers
#'
#' @inheritParams shared-params
#' @returns A list of raw issue closer objects as returned by [gh::gh_gql()].
#' @keywords internal
FetchRepoIssueClosersRaw <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strNameWithOwner <- paste0(strOwner, "/", strRepo)
  lIssueClosers <- list()
  strCursor <- NULL
  repeat {
    lBatch <- FetchRepoIssueClosersRawBatch(
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken,
      strCursor = strCursor
    )
    lNodes <- lBatch$data$repository$issues$nodes
    lNodes <- purrr::keep(lNodes, IsIssueCloserFromRepo, strNameWithOwner)
    lIssueClosers <- unique(c(lIssueClosers, lNodes))
    if (!isTRUE(lBatch$data$repository$issues$pageInfo$hasNextPage)) {
      break
    }
    strCursor <- lBatch$data$repository$issues$pageInfo$endCursor
  }
  lIssueClosers
}

#' Fetch a batch of raw repository issue closers
#'
#' @param strCursor (`character(1)`|`NULL`) The cursor to start fetching from.
#' @inheritParams shared-params
#' @returns A list of raw issue closer objects as returned by [gh::gh_gql()].
#' @keywords internal
FetchRepoIssueClosersRawBatch <- function(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strCursor = NULL
) {
  strAfter <- glue::glue('after: "{strCursor}", ') %|0|% ""
  strQuery <- PrepareGQLQuery(
    "issues(first: 100, states: CLOSED, <after> orderBy: {field: CREATED_AT, direction: ASC}) {",
    "  pageInfo {",
    "    hasNextPage",
    "    endCursor",
    "  }",
    "  nodes {",
    "    number",
    "    timelineItems(last: 1, itemTypes: [CLOSED_EVENT]) {",
    "      nodes {",
    "        ... on ClosedEvent {",
    "          closer {",
    "            __typename",
    "            ... on Commit {",
    "              oid",
    "            }",
    "            ... on PullRequest {",
    "              number",
    "              merged",
    "              repository {",
    "                nameWithOwner",
    "              }",
    "            }",
    "          }",
    "        }",
    "      }",
    "    }",
    "  }",
    "}",
    after = strAfter
  )
  FetchGQL(
    strQuery,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Check whether an issue closer originates from the target repository
#'
#' @param lIssueCloser (`list`) A single raw issue node.
#' @param strNameWithOwner (`character(1)`) `"owner/repo"` of the target repo.
#' @returns A length-1 `logical`.
#' @keywords internal
IsIssueCloserFromRepo <- function(lIssueCloser, strNameWithOwner) {
  if (length(lIssueCloser$timelineItems$nodes)) {
    lCloser <- lIssueCloser$timelineItems$nodes[[1]]$closer
    if (!identical(lCloser$`__typename`, "PullRequest")) {
      return(TRUE)
    }
    return(identical(lCloser$repository$nameWithOwner, strNameWithOwner))
  }
  return(FALSE)
}

#' Tibblify a single issue closer
#'
#' @param lIssueCloser (`list`) A single element of a raw issue closer object as
#'   returned by [FetchRepoIssueClosersRaw()].
#' @inherit FetchRepoIssueClosers return
#' @keywords internal
TibblifyIssueCloser <- function(lIssueCloser) {
  lCloser <- lIssueCloser$timelineItems$nodes[[1]]$closer
  if (is.null(lCloser)) {
    # Not really possible if they use the full workflow, but this is here to
    # avoid weird cases.
    return(NULL) # nocov
  }
  if (
    identical(lCloser$`__typename`, "PullRequest") && !isTRUE(lCloser$merged)
  ) {
    return(NULL)
  }
  tibble::tibble(
    Issue = lIssueCloser$number,
    CloserType = lCloser$`__typename`,
    CloserSHA = lCloser$oid %|0|% NA_character_,
    CloserPRNumber = lCloser$number %|0|% NA_integer_
  )
}
