# Wrap a GraphQL query with repository info

Wrap a GraphQL query with repository info

## Usage

``` r
GQLWrapper(strQuery, strOwner, strRepo)
```

## Arguments

- strQuery:

  (`length-1 character`) The GraphQL query (or sub-query).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

## Value

A single character string containing the full query.
