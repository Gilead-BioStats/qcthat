# Nest a qcthat_IssueTestMatrix by Milestone and Issue

Nest a qcthat_IssueTestMatrix by Milestone and Issue

## Usage

``` r
AsNestedIssueTestMatrix(x)
```

## Arguments

- x:

  (`qcthat_Object`) The qcthat object to format.

## Value

A tibble with `TestResults` nested by `Issue`, and `IssueTestResults`
nested by `Milestone`.
