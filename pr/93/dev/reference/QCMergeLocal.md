# Generate a QC report of issues probably related to changes between local git refs

Find issues associated with merging a source ref into a target ref based
purely on GitHub commit keywords, and generate a report about their test
status. This report is useful while you're developing a feature on a
branch other than the default branch, but you have not yet created a
pull request on GitHub.

## Usage

``` r
QCMergeLocal(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  chrKeywords = c("close", "closes", "closed", "fix", "fixes", "fixed", "resolve",
    "resolves", "resolved"),
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
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

- chrKeywords:

  (`character`) Keywords to search for just before issue numbers in
  commit messages. Defaults to the [GitHub issue-linking
  keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)

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

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md),
filtered to issues that will be closed by merging `strSourceRef` into
`strTargetRef`, using the [GitHub keywords for linking issues to pull
requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword).

## See also

[`QCMergeGH()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeGH.md)
to use the GitHub API to find more formal, concrete connections between
issues and the commits that closed them, and
[`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md)
for a wrapper around
[`QCMergeGH()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeGH.md)
that specifically looks at the commits associated with a specified pull
request.

## Examples

``` r
if (FALSE) { # interactive()

  # This will only make sense if you are working in a git repository and have
  # an active branch that is different from the default branch.
  QCMergeLocal()
}
```
