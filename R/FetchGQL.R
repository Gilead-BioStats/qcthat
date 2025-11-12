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
