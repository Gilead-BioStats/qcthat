#' Find the owner of the target repository
#'
#' A wrapper to safely call [gh::gh_tree_remote()] and extract the owner
#' (`"username"`).
#'
#' @inheritParams shared-params
#'
#' @returns A length-1 `character` vector representing the GitHub owner of the
#'   repository at `strPkgRoot`.
#' @export
#'
#' @examplesIf interactive()
#'   GetGHOwner()
GetGHOwner <- function(strPkgRoot = ".") {
  remote <- GetGHRemote(strPkgRoot)
  return(remote[["username"]])
}

#' Find the name of the target repository
#'
#' A wrapper to safely call [gh::gh_tree_remote()] and extract the name
#' (`"repo"`).
#'
#' @inheritParams shared-params
#'
#' @returns A length-1 `character` vector representing the GitHub repo name of
#'   the repository at `strPkgRoot`.
#' @export
#'
#' @examplesIf interactive()
#'   GetGHRepo()
GetGHRepo <- function(strPkgRoot = ".") {
  remote <- GetGHRemote(strPkgRoot)
  return(remote[["repo"]])
}

#' Find the target repository
#'
#' A wrapper to safely call [gh::gh_tree_remote()] if the project uses git.
#'
#' @inheritParams shared-params
#'
#' @returns A list representing the GitHub repository at `strPkgRoot`.
#' @keywords internal
GetGHRemote <- function(strPkgRoot = ".") {
  # nocov start
  if (UsesGit(strPkgRoot)) {
    repo <- gert::git_find(strPkgRoot)
    return(gh::gh_tree_remote(repo))
  }
  # nocov end
}

#' Check whether a package uses git
#'
#' @inheritParams shared-params
#' @returns A length-1 `logical` indicating whether the package at `strPkgRoot`
#'   is a git repository.
#' @keywords internal
UsesGit <- function(strPkgRoot = ".") {
  repo <- tryCatch(gert::git_find(strPkgRoot), error = function(e) NULL)
  !is.null(repo)
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
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
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
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
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
