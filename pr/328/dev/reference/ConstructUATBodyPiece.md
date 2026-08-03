# Construct the body of the UAT report comment

Construct the body of the UAT report comment

## Usage

``` r
ConstructUATBodyPiece(dfIssues, strHeader, strBulletTemplate, strFooter = NULL)
```

## Arguments

- dfIssues:

  (`data.frame`) A data frame with columns `ParentIssue`, `UATIssue`,
  `Description`, `Disposition`, `Owner`, and `Repo`.

- strHeader:

  (`length-1 character`) A header to introduce the issues in this
  section of the report.

- strBulletTemplate:

  (`length-1 character`) A template for the bullet points describing
  each issue in this section of the report, with glue syntax for the
  relevant columns of `dfIssues`.

- strFooter:

  (`length-1 character` or `NULL`) An optional footer to conclude this
  section of the report.

## Value

A string containing the body of this part of the UAT report comment,
formatted in GitHub markdown.
