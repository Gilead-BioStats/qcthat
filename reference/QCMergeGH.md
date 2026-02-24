# Generate a QC report of issues associated with a GitHub merge

Finds all commits in `strSourceRef` that are not in `strTargetRef`,
finds all pull requests associated with those commits, finds all issues
associated with those pull requests (according to GitHub's graph of
connections between issues and commits), and generates a QC report for
those issues. This is a more robust check than
[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/reference/QCMergeLocal.md).
Note: If the comparison involves more than 5000 commits, increase
`intPageMax` to fetch additional commits in batches of 100.

## Usage

``` r
QCMergeGH(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  intPageMax = 100L,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  dfITM = NULL,
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

- intPageMax:

  (`length-1 integer`) The maximum number of pages of commits to fetch
  from the GitHub API. Each page contains up to 100 commits. Defaults to
  100, which fetches up to 10,000 commits. You likely never need to
  increase this number, but try a larger number if a merge involves a
  very large number of commits in a very large repository.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md)).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md),
filtered to issues that are associated with pull requests that will be
merged when `strSourceRef` is merged into `strTargetRef`.

## See also

[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/reference/QCMergeLocal.md)
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
