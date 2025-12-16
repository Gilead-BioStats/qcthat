# Use a GitHub Action to QC a milestone

Install a GitHub Action into a package repository to generate a QC
report with
[`QCMilestones()`](https://gilead-biostats.github.io/qcthat/reference/QCMilestones.md)
of issues associated with a particular milestone. We recommend reviewing
the generated action to determine whether you would like to turn any
features off. Note: When triggered by a release, the workflow looks for
milestones that match the title of the release or the name of the tag
attached to the release. If the names do not match, the workflow will
fail.

## Usage

``` r
Action_QCMilestone(lglOverwrite = FALSE, strPkgRoot = ".")
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
