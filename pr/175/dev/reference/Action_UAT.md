# Use a GitHub Action to manage UAT

Install a GitHub Action into a package repository to manage the use
acceptance testing process with
[`TriggerUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/TriggerUAT.md).
The workflow triggers when issues are closed, and, if they are labeled
`"qcthat-uat"`, it triggers reruns of the
[`Action_QCPRIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/Action_QCPRIssues.md)
action for any open pull requests that reference the UAT issue.

## Usage

``` r
Action_UAT(lglOverwrite = FALSE, strPkgRoot = ".")
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

  Action_UAT()
}
```
