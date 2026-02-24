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
#' @returns A list representing the GitHub repository at `strPkgRoot`.
#' @keywords internal
GetGHRemote <- function(strPkgRoot = ".") {
  if (UsesGit(strPkgRoot)) {
    lRemotes <- GetGHRemoteList(strPkgRoot)
    if (length(lRemotes)) {
      strURL <- lRemotes$url[lRemotes$name == "upstream"] %|0|%
        lRemotes$url[lRemotes$name == "origin"]
      lGHRemote <- list(
        username = stringr::str_extract(
          strURL,
          "(https://github.com/)([^/]+)",
          group = 2
        ),
        repo = stringr::str_extract(
          strURL,
          "(https://github.com/)([^/]+)/([^.]+)",
          group = 3
        )
      )
      if (
        length(lGHRemote$username) &&
          !is.na(lGHRemote$username) &&
          length(lGHRemote$repo) &&
          !is.na(lGHRemote$repo)
      ) {
        return(lGHRemote)
      }
    }
    # nocov start
    strRepo <- gert::git_find(strPkgRoot)
    return(gh::gh_tree_remote(strRepo))
    # nocov end
  }
}

#' Wrapper around gert::git_remote_list() for mocking
#'
#' @inheritParams shared-params
#' @returns The result of the [gert::git_remote_list()] call.
#' @keywords internal
GetGHRemoteList <- function(strPkgRoot) {
  gert::git_remote_list(strPkgRoot) # nocov
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

#' A classed GitHub response for testing
#'
#' @returns An empty list with class "gh_response".
#' @keywords internal
EmptyGHResponse <- function() {
  structure(list(), class = c("gh_response", "list"))
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

#' Fetch a vector of values from GitHub GraphQL API using a builder function
#'
#' @param x (`vector`) A vector of inputs to process.
#' @param fnBuildQuery (`function`) A function that takes a single element of
#'   `x` and returns a character string representing a GraphQL sub-query for
#'   that element.
#' @param vecProto (`vector`) A prototype vector to return if `x` is empty.
#' @inheritParams shared-params
#' @returns A sorted, unique vector of values fetched from GitHub, or
#'   `vecProto`.
#' @keywords internal
FetchVectorFromGQL <- function(
  x,
  fnBuildQuery,
  vecProto = integer(),
  intBatchSize = 50,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
) {
  if (!length(x)) {
    return(vecProto)
  }
  lBatches <- unname(split(x, ceiling(seq_along(x) / intBatchSize)))
  lAllResults <- purrr::map(lBatches, function(vecBatch) {
    FetchGQL(
      paste(purrr::map_chr(vecBatch, fnBuildQuery), collapse = "\n"),
      strOwner = strOwner,
      strRepo = strRepo,
      strGHToken = strGHToken
    )
  })
  vecPrepared <- CompletelyFlatten(lAllResults) %||% vecProto
  return(vecPrepared)
}
