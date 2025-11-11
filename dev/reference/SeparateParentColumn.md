# Parse the ParentUrl column into its components

Parse the ParentUrl column into its components

## Usage

``` r
SeparateParentColumn(dfIssues)
```

## Arguments

- dfIssues:

  (`data.frame`) Data frame with a `ParentUrl` column.

## Value

The input data frame with `ParentUrl` split into `ParentOwner`,
`ParentRepo`, and `ParentNumber` columns.
