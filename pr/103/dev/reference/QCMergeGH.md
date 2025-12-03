# Generate a QC report of issues associated with a GitHub merge

Finds all commits in `strSourceRef` that are not in `strTargetRef`,
finds all pull requests associated with those commits, finds all issues
associated with those pull requests (according to GitHub's graph of
connections between issues and commits), and generates a QC report for
those issues. This is a more robust check than
[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeLocal.md).

## Usage

``` r
QCMergeGH(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
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

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

- strTargetRef:

  (`length-1 character`) Name of the git reference that will be merged
  into. Defaults to the default branch of this repository.

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
filtered to issues that are associated with pull requests that will be
merged when `strSourceRef` is merged into `strTargetRef`.

## See also

[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeLocal.md)
to use local git data to guess connections between issues and the
commits that closed them.

## Examples

``` r
if (FALSE) { # interactive()

  # This will only make sense if you are working in a git repository and have
  # an active branch that is different from the default branch.
  QCMergeGH()
}
```
