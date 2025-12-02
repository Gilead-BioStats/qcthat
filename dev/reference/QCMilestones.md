# Generate a QC report of a specific milestone or milestones

Generate a report about the test status of issues in a milestone or
milestones.

## Usage

``` r
QCMilestones(
  chrMilestones,
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
)
```

## Arguments

- chrMilestones:

  (`character`) The name(s) of milestone(s) to filter issues by.

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

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md),
filtered to the indicated issues.

## Examples

``` r
if (FALSE) { # interactive()

  # This will only make sense if you are working in a git repository that has
  # a milestone named "v0.1.0" on GitHub.
  QCMilestones("v0.1.0")
}
```
