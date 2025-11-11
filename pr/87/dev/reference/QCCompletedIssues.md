# Generate a QC report of completed issues

A simple wrapper around
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)
that filters the resulting issue-test matrix to only include issues that
were closed as "completed".

## Usage

``` r
QCCompletedIssues(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

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
