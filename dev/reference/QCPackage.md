# Generate a QC report for a package

A QC report combines information about GitHub issues associated with a
package (see
[`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssues.md))
and testthat test results for the package (see
[`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md))
using
[`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md).

## Usage

``` r
QCPackage(
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  envCall = rlang::caller_env()
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

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md).

## Examples

``` r
if (FALSE) { # interactive()

  QCPackage()
}
```
