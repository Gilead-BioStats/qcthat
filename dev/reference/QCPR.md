# Generate a QC report of issues associated with a GitHub pull request

Find issues associated with a GitHub pull request, whether they were
added via keywords, using the pull request sidebar, or using the issue
sidebar. See [GitHub Docs: Link a pull request to an
issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
for details on how issues can become associated with a pull request.

## Usage

``` r
QCPR(
  intPRNumber = GuessPRNumber(strPkgRoot, strOwner, strRepo, strGHToken),
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

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

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

  (`length-1 character`) GitHub token with permissions to read issues.

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md),
filtered to issues that will be closed by merging the pull request.

## See also

[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeLocal.md)
to use local git data to guess connections between issues and the
commits that closed them.

## Examples

``` r
if (FALSE) { # interactive()

  # You must have at least one pull request open in the GitHub repository
  # associated with the current git repository for this to return any
  # results.

  QCPR()
}
```
