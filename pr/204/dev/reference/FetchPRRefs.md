# Fetch the source and target refs for a PR

Fetch the source and target refs for a PR

## Usage

``` r
FetchPRRefs(
  intPRNumber = GuessPRNumber(".", strOwner, strRepo, strGHToken),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lPRs = NULL,
  envCall = rlang::caller_env()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

- lPRs:

  (`list` or `NULL`) Optional list of raw pull request objects as
  returned by
  [`FetchRawRepoPRs()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRawRepoPRs.md).
  If provided, the PR will be looked up from this list instead of
  fetching individually from the API.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A named character vector with `strSourceRef` and `strTargetRef`.
