# Get rid of PRs in the issues list

Get rid of PRs in the issues list

## Usage

``` r
RemovePRsFromIssues(lIssuesRaw)
```

## Arguments

- lIssuesRaw:

  (`list`) List of raw issue objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

A list of issue objects without PRs.
