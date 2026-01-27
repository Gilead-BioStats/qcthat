# Load UAT issues from disk

Load a registry of user acceptance testing (UAT) issues from an RDS file
into the internal package environment.

## Usage

``` r
LoadUATIssues(strPath = "UATIssues.rds")
```

## Arguments

- strPath:

  (`length-1 character`) Path to the UAT file. Defaults to
  `"UATIssues.rds"` in the working directory.

## Value

The UAT issues data frame, invisibly.
