# Enrich data frame with issue details

Enrich data frame with issue details

## Usage

``` r
EnrichWithIssueDetails(dfPotentialIssues, strOwner, strRepo, strGHToken)
```

## Arguments

- dfPotentialIssues:

  (`tibble`) A data frame as returned by
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

The input data frame with `PotentialIssues` enriched to
`PotentialIssueDetails` with issue details.
