# Generate a QC report of completed issues

A simple wrapper around
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)
that filters the resulting issue-test matrix to only include issues that
were closed as "completed".

## Usage

``` r
QCCompletedIssues(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels()
)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md),
filtered to issues that were closed as completed.

## Examples

``` r
if (FALSE) { # interactive()

  QCCompletedIssues()
}
```
