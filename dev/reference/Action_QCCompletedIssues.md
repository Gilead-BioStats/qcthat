# Use a GitHub Action to QC completed issues

Install a GitHub Action into a package repository to generate a QC
report of completed issues with
[`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCCompletedIssues.md).
We recommend reviewing the generated action to determine whether you
would like to turn any features off.

## Usage

``` r
Action_QCCompletedIssues(lglOverwrite = FALSE, strPkgRoot = ".")
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

  Action_QCCompletedIssues()
}
```
