# Create a data frame of commits that are in one git ref but not another

Create a data frame of commits that are in one git ref but not another

## Usage

``` r
CompileGitLogDiff(
  strSourceRef,
  strTargetRef,
  strPkgRoot = ".",
  intMaxCommits = 100000L
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

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

## Value

A data frame of commits that are in `strSourceRef` but not in
`strTargetRef`, as returned by
[`GetGitLog()`](https://gilead-biostats.github.io/qcthat/reference/GetGitLog.md).
