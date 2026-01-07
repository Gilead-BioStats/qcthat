# Fetch the source and target refs for a PR

Fetch the source and target refs for a PR

## Usage

``` r
FetchPRRefs(
  intPRNumber = GuessPRNumber(".", strOwner, strRepo, strGHToken),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A named character vector with `strSourceRef` and `strTargetRef`.
