# Apply ignored labels to an Issue Test Matrix

Apply ignored labels to an Issue Test Matrix

## Usage

``` r
ApplyITMIgnoredLabels(dfITM, chrIgnoredLabels)
```

## Arguments

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/AsIssueTestMatrix.md).

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

## Value

A filtered `qcthat_IssueTestMatrix` object with issues that are tagged
to any of the specified ignored labels removed. The returned object has
an attribute `IgnoredLabels` which is a named list of integer vectors of
the issues that were removed for each ignored label (or an empty named
list if `chrIgnoredLabels` is empty).
