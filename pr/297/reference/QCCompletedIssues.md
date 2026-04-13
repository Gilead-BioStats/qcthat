# Generate a QC report of completed issues

A simple wrapper around
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md)
that filters the resulting issue-test matrix to only include issues that
were closed as "completed".

## Usage

``` r
QCCompletedIssues(
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels(),
  dfITM = NULL,
  envCall = rlang::caller_env()
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

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md)).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md),
filtered to issues that were closed as completed.

## Examples

``` r
if (FALSE) { # interactive()

  QCCompletedIssues()
}
```
