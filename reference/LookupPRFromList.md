# Look up a PR from a list by number

Look up a PR from a list by number

## Usage

``` r
LookupPRFromList(lPRs, intPRNumber, envCall = rlang::caller_env())
```

## Arguments

- lPRs:

  A list of raw pull request objects as returned by
  [`FetchRawRepoPRs()`](https://gilead-biostats.github.io/qcthat/reference/FetchRawRepoPRs.md).

- intPRNumber:

  (`length-1 integer`) The pull request number to look up.

- envCall:

  (`environment`) The calling environment for error messages.

## Value

A list representing a raw pull request object.
