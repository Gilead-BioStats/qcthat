# Fetch the latest pull request number for a GitHub repository

Fetch the latest pull request number for a GitHub repository, optionally
filtered by state.

## Usage

``` r
FetchLatestRepoPRNumber(
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token(),
  strState = c("open", "closed", "all")
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strState:

  (`length-1 character`) State of issues or pull requests to fetch. Must
  be one of `"open"`, `"closed"`, or `"all"`. Defaults to `"open"` for
  pull requests and `"all"` for issues.

## Value

The latest pull request number as an integer, or `NA_integer_` if no
pull requests are found.

## Examples

``` r
if (FALSE) { # interactive()

  FetchLatestRepoPRNumber()
}
```
