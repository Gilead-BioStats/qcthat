# Log ExpectUserAccepts results

Log ExpectUserAccepts results

## Usage

``` r
LogUAT(
  intParentIssue,
  intUATIssue,
  strDescription,
  strDisposition,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  dttmTimestamp = Sys.time()
)
```

## Arguments

- intParentIssue:

  (`length-1 integer`) The number of the parent issue in a parent-child
  issue relationship.

- intUATIssue:

  (`integer`) The number of an issue that tracks user-acceptance
  testing.

- strDescription:

  (`length-1 character`) A brief description of a user expectation.

- strDisposition:

  (`length-1 character`) The result of a test, such as "pass", "fail",
  or "skip", or "accepted" or "pending" for UAT.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- dttmTimestamp:

  (`POSIXct`) A system timestamp.

## Value

The value of `envQcthat$UATIssues`, invisibly
