# Build a paginated GraphQL fragment for a PR's commits

Build a paginated GraphQL fragment for a PR's commits

## Usage

``` r
BuildPRCommitsFragmentPaginated(intPR, strCursor)
```

## Arguments

- intPR:

  (`integer(1)`) PR number.

- strCursor:

  (`character(1)`) Pagination cursor.

## Value

A character string with the GraphQL fragment.
