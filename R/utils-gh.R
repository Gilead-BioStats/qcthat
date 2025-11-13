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

#' Wrapper for GitHub GraphQL API calls
#'
#' @inheritParams shared-params
#' @param strQuery (`length-1 character`) The GraphQL query (or sub-query).
#' @param ... Additional parameters passed to [gh::gh_gql()].
#'
#' @returns The result of the [gh::gh_gql()] call.
#' @keywords internal
FetchGQL <- function(
  strQuery,
  ...,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  # nocov start
  strQueryPrepared <- GQLWrapper(strQuery, strOwner, strRepo)
  gh::gh_gql(strQueryPrepared, ..., .token = strGHToken)
  # nocov end
}

#' Prepare a GraphQL query string
#'
#' @param ... (`character`) Lines of the query.
#' @param strOpen (`length-1 character`) The opening delimiter for
#'   [glue::glue()].
#' @param strClose (`length-1 character`) The closing delimiter for
#'   [glue::glue()].
#'
#' @returns A single character string containing the formatted query.
#' @keywords internal
PrepareGQLQuery <- function(
  ...,
  strOpen = "<",
  strClose = ">",
  envCall = rlang::caller_env()
) {
  glue::glue(
    ...,
    .sep = "\n",
    .open = strOpen,
    .close = strClose,
    .envir = envCall
  )
}

#' Wrap a GraphQL query with repository info
#'
#' @inheritParams FetchGQL
#' @inheritParams shared-params
#' @returns A single character string containing the full query.
#' @keywords internal
GQLWrapper <- function(strQuery, strOwner, strRepo) {
  PrepareGQLQuery(
    'query { repository(owner: "<strOwner>", name: "<strRepo>") {',
    "<query>",
    "} }",
    query = strQuery,
    strOwner = strOwner,
    strRepo = strRepo
  )
}
