# Use a GitHub Action to manage qcthat

Install a GitHub Action into a package repository to manage qcthat
Quality Control with
[`TriggerUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/TriggerUAT.md),
[`CommentAllReports()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentAllReports.md),
and
[`AttachReleaseReports()`](https://gilead-biostats.github.io/qcthat/dev/reference/AttachReleaseReports.md).
We recommend reviewing the generated action to determine whether you
would like to turn any features off.

## Usage

``` r
Action_qcthat(lglOverwrite = FALSE, strPkgRoot = ".")
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

  Action_qcthat()
}
```
