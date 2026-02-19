#' Fetch all PRs that reference a specific issue
#'
#' @param strPRState (`character`) States to include in the fetch. Valid values
#'   are `"open"`, `"closed"`, and `"merged"`. By default all states are allowed.
#' @inheritParams shared-params
#' @returns A tibble containing PR details (PR number, State, HeadRef, SHA).
#' @keywords internal
FetchAllIssuePRRefs <- function(
  intIssue,
  strPRState = c("open", "closed", "merged"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  lPRCrossRefs <- FetchAllIssuePRRefsRaw(
    intIssue,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  strPRState <- match.arg(strPRState, several.ok = TRUE)
  lPRCrossRefNodes <- purrr::keep(
    lPRCrossRefs$data$repository$issue$timelineItems$nodes,
    \(lPRCrossRef) {
      isTRUE(any(lPRCrossRef$source$state == toupper(strPRState)))
    }
  )

  purrr::map(lPRCrossRefNodes, \(lPRCrossRef) {
    tibble::tibble(
      PR = lPRCrossRef$source$number,
      State = tolower(lPRCrossRef$source$state),
      HeadRef = lPRCrossRef$source$headRefName,
      SHA = lPRCrossRef$source$commits$nodes[[1]]$commit$oid
    )
  }) |>
    purrr::list_rbind()
}

#' Fetch the raw GraphQL response for PRs referencing an issue
#'
#' @inheritParams shared-params
#' @returns A list containing the raw GraphQL response.
#' @keywords internal
FetchAllIssuePRRefsRaw <- function(
  intIssue,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  strQuery <- BuildIssuePRRefsQuery(intIssue)
  FetchGQL(
    strQuery = strQuery,
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
}

#' Build a GraphQL query to find PRs referencing a specific issue
#'
#' @inheritParams shared-params
#' @returns A character string for the GraphQL query.
#' @keywords internal
BuildIssuePRRefsQuery <- function(intIssue) {
  PrepareGQLQuery(
    "issue(number: <issue>) {",
    "  timelineItems(first: 100, itemTypes: [CROSS_REFERENCED_EVENT]) {",
    "    nodes {",
    "      ... on CrossReferencedEvent {",
    "        source {",
    "          ... on PullRequest {",
    "            number",
    "            state",
    "            headRefName",
    "            commits(last:1) {",
    "              nodes {",
    "                commit {",
    "                  oid",
    "                }",
    "              }",
    "            }",
    "          }",
    "        }",
    "      }",
    "    }",
    "  }",
    "}",
    issue = intIssue
  )
}
