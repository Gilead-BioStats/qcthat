# Use a GitHub Action to QC pull-request-associated issues

Install a GitHub Action into a package repository to generate a QC
report with
[`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md)
of issues that will be closed by the triggering pull request. We
recommend reviewing the generated action to determine whether you would
like to turn any features off. Note: This workflow cannot be triggered
when an issue is connected to (or disconnected from) the pull request
via the "Development" UI of the PR or issue. In that situation, either
trigger the workflow manually, or edit the PR body to mention the issue
(such as "Closes \#55").

## Usage

``` r
Action_QCPRIssues(lglOverwrite = FALSE, strPkgRoot = ".")
```

## Arguments

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

The path to the created GitHub Action YAML file (invisibly).

## Examples

``` r
if (FALSE) { # interactive()

  Action_QCPRIssues()
}
```
