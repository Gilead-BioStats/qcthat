FetchMergeCommitSHAs <- function(
  strSourceRef,
  strTargetRef,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lCompareRaw <- CallGHAPI(
    "GET /repos/{owner}/{repo}/compare/{target}...{source}",
    strOwner = strOwner,
    strRepo = strRepo,
    target = strTargetRef,
    source = strSourceRef,
    strGHToken = strGHToken
  )
  return(
    sort(unique(purrr::map_chr(lCompareRaw$commits, "sha")))
  )
}

FetchSHAPRNumbers <- function(
  chrSHA,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  lSHAPRs <- FetchGQL(
    PrepareGQLQuery(
      'object(oid: "<chrSHA>") {',
      "... on Commit {",
      "associatedPullRequests(first: 100) { nodes { number } }",
      "}",
      "}",
      chrSHA = chrSHA
    ),
    strOwner = strOwner,
    strRepo = strRepo,
    strGHToken = strGHToken
  )
  sort(unique(
    purrr::map_int(
      lSHAPRs$data$repository$object$associatedPullRequests$nodes,
      "number"
    )
  ))
}

FetchGQL <- function(
  strQuery,
  ...,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
) {
  strQueryPrepared <- GQLWrapper(strQuery, strOwner, strRepo)
  gh::gh_gql(strQueryPrepared, ..., .token = strGHToken)
}

PrepareGQLQuery <- function(..., strOpen = "<", strClose = ">") {
  glue::glue(
    ...,
    .sep = "\n",
    .open = strOpen,
    .close = strClose
  )
}

GQLWrapper <- function(strQuery, strOwner, strRepo) {
  PrepareGQLQuery(
    'query { repository(owner: "<strOwner>", name: "<strRepo>") {',
    "<strQuery>",
    "} }",
    strQuery = strQuery,
    strOwner = strOwner,
    strRepo = strRepo
  )
}
