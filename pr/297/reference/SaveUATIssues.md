# Save UAT issues to disk

Save the internal registry of user acceptance testing (UAT) issues to an
RDS file. This allows the UAT state to be persisted across R sessions.

## Usage

``` r
SaveUATIssues(strPath = "UATIssues.rds")
```

## Arguments

- strPath:

  (`length-1 character`) Path to the UAT file. Defaults to
  `"UATIssues.rds"` in the working directory.

## Value

`NULL` invisibly.
