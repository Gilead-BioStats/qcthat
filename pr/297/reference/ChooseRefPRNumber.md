# Choose between multiple PRs

Choose between multiple PRs

## Usage

``` r
ChooseRefPRNumber(dfPRs, strSourceRef = GetActiveBranch())
```

## Arguments

- dfPRs:

  (`data.frame`) Data frame of pull requests as returned by
  [`FetchRepoPRs()`](https://gilead-biostats.github.io/qcthat/reference/FetchRepoPRs.md).

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

## Value

A `length-1 integer` pull request number.
