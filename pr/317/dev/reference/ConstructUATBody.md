# Construct the body of the UAT report comment

Construct the body of the UAT report comment

## Usage

``` r
ConstructUATBody(dfRelevantUAT)
```

## Arguments

- dfRelevantUAT:

  (`data.frame`) A data frame with columns `ParentIssue`, `UATIssue`,
  `Description`, `Disposition`, `Owner`, and `Repo`.

## Value

A string containing the body of the UAT report comment, formatted in
GitHub markdown.
