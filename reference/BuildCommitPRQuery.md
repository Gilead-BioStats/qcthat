# Build a GraphQL sub-query for a single commit's PRs

Build a GraphQL sub-query for a single commit's PRs

## Usage

``` r
BuildCommitPRQuery(chrSHA, intIndex)
```

## Arguments

- chrSHA:

  (`length-1 character`) The commit SHA.

- intIndex:

  (`length-1 integer`) A unique index for the query alias.

## Value

A character string for the GraphQL sub-query.
