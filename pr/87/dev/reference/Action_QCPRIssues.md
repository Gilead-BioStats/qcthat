# Use a GitHub Action to QC pull-request-associated issues

Install a GitHub Action into a package repository to generate a QC
report with
[`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCCompletedIssues.md)
of issues that will be closed by the triggering pull request. We
recommend reviewing the generated action to determine whether you would
like to turn any features off.

## Usage

``` r
Action_QCPRIssues(lglOverwrite = FALSE, strPkgRoot = ".")
```

## Arguments

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

## Value

The path to the created GitHub Action YAML file (invisibly).

## Examples

``` r
if (FALSE) { # interactive()

  Action_QCPRIssues()
}
```
