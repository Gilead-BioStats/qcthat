#' Fetch repository issue closers
#'
#' Fetch the closers (commits or pull requests) for all closed issues in a
#' repository. In addition to formal `ClosedEvent`s (where a commit or merged
#' PR directly closed the issue), this also includes `ConnectedEvent`s (where a
#' merged PR was manually linked to the issue) that have not been subsequently
#' cancelled by a `DisconnectedEvent`. An issue may appear more than once if it
#' has multiple valid closers.
#'
#' @inheritParams shared-params
#' @returns A [tibble::tibble()] with columns:
#'   - `Issue`: Issue number.
#'   - `CloserType`: Type of the closer, either `Commit` or `PullRequest`.
#'   - `CloserSHA`: SHA of the commit that closed the issue. For `Commit`
#'   closers, this is the commit OID directly. For `PullRequest` closers, this
#'   is the merge commit SHA.
#'   - `CloserPRNumber`: Number of the pull request that closed the issue, or
#'   `NA` if the issue was closed by a commit.
#'   - `CloserDate`: Timestamp of the closing event as a character string.
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
      CloserPRNumber = integer(),
      CloserDate = character()
    )),
    purrr::map(lIssueClosers, TibblifyIssueCloser)
  ) |>
    purrr::list_rbind() |>
    dplyr::arrange(dplyr::desc(.data$CloserDate)) |>
    dplyr::distinct(
      .data$Issue,
      .data$CloserType,
      .data$CloserSHA,
      .data$CloserPRNumber,
      .keep_all = TRUE
    ) |>
    dplyr::arrange(.data$Issue)
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
    "    timelineItems(last: 10, itemTypes: [CLOSED_EVENT, CONNECTED_EVENT, DISCONNECTED_EVENT]) {",
    "      nodes {",
    "        __typename",
    "        ... on ClosedEvent {",
    "          createdAt",
    "          closer {",
    "            __typename",
    "            ... on Commit {",
    "              oid",
    "            }",
    "            ... on PullRequest {",
    "              number",
    "              merged",
    "              mergeCommit { oid }",
    "              repository {",
    "                nameWithOwner",
    "              }",
    "            }",
    "          }",
    "        }",
    "        ... on ConnectedEvent {",
    "          createdAt",
    "          subject {",
    "            __typename",
    "            ... on PullRequest {",
    "              number",
    "              merged",
    "              mergeCommit { oid }",
    "              repository {",
    "                nameWithOwner",
    "              }",
    "            }",
    "          }",
    "        }",
    "        ... on DisconnectedEvent {",
    "          subject {",
    "            __typename",
    "            ... on PullRequest {",
    "              number",
    "              repository { nameWithOwner }",
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
  nodes <- lIssueCloser$timelineItems$nodes
  if (!length(nodes)) {
    return(FALSE)
  }
  purrr::some(nodes, function(lNode) {
    strTypename <- lNode$`__typename`
    if (identical(strTypename, "ConnectedEvent")) {
      if (!identical(lNode$subject$`__typename`, "PullRequest")) {
        return(FALSE)
      }
      return(identical(
        lNode$subject$repository$nameWithOwner,
        strNameWithOwner
      ))
    }
    if (identical(strTypename, "DisconnectedEvent")) {
      return(FALSE)
    }
    # ClosedEvent (or legacy untyped node with $closer)
    lCloser <- lNode$closer
    if (!identical(lCloser$`__typename`, "PullRequest")) {
      return(TRUE)
    }
    identical(lCloser$repository$nameWithOwner, strNameWithOwner)
  })
}

#' Tibblify a single issue closer
#'
#' @param lIssueCloser (`list`) A single element of a raw issue closer object as
#'   returned by [FetchRepoIssueClosersRaw()].
#' @inherit FetchRepoIssueClosers return
#' @keywords internal
TibblifyIssueCloser <- function(lIssueCloser) {
  intIssue <- lIssueCloser$number
  nodes <- lIssueCloser$timelineItems$nodes

  # Resolve ConnectedEvent/DisconnectedEvent pairs. Each ConnectedEvent
  # increments a per-PR counter (and records the most recent node); each
  # DisconnectedEvent decrements it. Only PRs with a net count > 0 survive.
  lConnected <- purrr::reduce(
    nodes,
    function(acc, lNode) {
      strTypename <- lNode$`__typename`
      if (
        identical(strTypename, "ConnectedEvent") &&
          identical(lNode$subject$`__typename`, "PullRequest")
      ) {
        strPR <- as.character(lNode$subject$number)
        if (is.null(acc[[strPR]])) {
          acc[[strPR]] <- list(count = 0L, node = NULL)
        }
        acc[[strPR]]$count <- acc[[strPR]]$count + 1L
        acc[[strPR]]$node <- lNode
      } else if (
        identical(strTypename, "DisconnectedEvent") &&
          identical(lNode$subject$`__typename`, "PullRequest")
      ) {
        strPR <- as.character(lNode$subject$number)
        if (!is.null(acc[[strPR]])) {
          acc[[strPR]]$count <- max(0L, acc[[strPR]]$count - 1L)
        }
      }
      acc
    },
    .init = list()
  )

  # Rows from ClosedEvent nodes (detected by presence of $closer)
  lClosedRows <- purrr::keep(nodes, \(n) !is.null(n$closer)) |>
    purrr::map(function(lNode) {
      lCloser <- lNode$closer
      if (
        !identical(lCloser$`__typename`, "Commit") &&
          !identical(lCloser$`__typename`, "PullRequest")
      ) {
        return(NULL)
      }
      if (
        identical(lCloser$`__typename`, "PullRequest") &&
          !isTRUE(lCloser$merged)
      ) {
        return(NULL)
      }
      tibble::tibble(
        Issue = intIssue,
        CloserType = lCloser$`__typename`,
        CloserSHA = lCloser$oid %|0|%
          lCloser$mergeCommit$oid %|0|%
          NA_character_,
        CloserPRNumber = lCloser$number %|0|% NA_integer_,
        CloserDate = lNode$createdAt %|0|% NA_character_
      )
    })

  # Rows from surviving ConnectedEvent nodes
  lConnectedRows <- purrr::keep(lConnected, \(x) x$count > 0L) |>
    purrr::map(function(lEntry) {
      lNode <- lEntry$node
      lSubject <- lNode$subject
      if (!isTRUE(lSubject$merged)) {
        return(NULL)
      } # nocov
      tibble::tibble(
        Issue = intIssue,
        CloserType = lSubject$`__typename`,
        CloserSHA = lSubject$mergeCommit$oid %|0|% NA_character_,
        CloserPRNumber = lSubject$number %|0|% NA_integer_,
        CloserDate = lNode$createdAt %|0|% NA_character_
      )
    })

  result <- c(lClosedRows, lConnectedRows) |> purrr::list_rbind()
  if (!nrow(result)) {
    return(NULL)
  }
  result
}
