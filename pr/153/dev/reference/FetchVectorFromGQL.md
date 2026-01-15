# Fetch a vector of values from GitHub GraphQL API using a builder function

Fetch a vector of values from GitHub GraphQL API using a builder
function

## Usage

``` r
FetchVectorFromGQL(
  x,
  fnBuildQuery,
  vecProto = integer(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- x:

  (`vector`) A vector of inputs to process.

- fnBuildQuery:

  (`function`) A function that takes a single element of `x` and returns
  a character string representing a GraphQL sub-query for that element.

- vecProto:

  (`vector`) A prototype vector to return if `x` is empty.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

A sorted, unique vector of values fetched from GitHub, or `vecProto`.
