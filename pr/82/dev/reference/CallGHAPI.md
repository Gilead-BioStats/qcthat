# Wrapper around gh::gh() for mocking

Wrapper around gh::gh() for mocking

## Usage

``` r
CallGHAPI(
  strEndpoint,
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  ...
)
```

## Arguments

- strEndpoint:

  (`length-1 character`) The endpoint to call, e.g.,
  `"GET /repos/{owner}/{repo}/issues"`.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- ...:

  Additional parameters passed to
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

The result of the [`gh::gh()`](https://gh.r-lib.org/reference/gh.html)
call.
