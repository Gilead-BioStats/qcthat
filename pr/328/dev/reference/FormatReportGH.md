# Format a QC report in GitHub markdown

Format a QC report in GitHub markdown

## Usage

``` r
FormatReportGH(dfITM)
```

## Arguments

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-public.github.io/qcthat/dev/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-public.github.io/qcthat/dev/reference/QCPackage.md)).

## Value

A string containing the report formatted in GitHub markdown.
