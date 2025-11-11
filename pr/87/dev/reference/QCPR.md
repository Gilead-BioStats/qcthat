# Generate a QC report of issues associated with a GitHub pull request

Find issues associated with a GitHub pull request, whether they were
added via keywords, using the pull request sidebar, or using the issue
sidebar. See [GitHub Docs: Link a pull request to an
issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
for details on how issues can become associated with a pull request.

## Usage

``` r
QCPR(
  intPRNumber = FetchLatestRepoPRNumber(strOwner, strRepo, strGHToken, "open"),
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  intMaxCommits = 100000L
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

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

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md),
filtered to issues that will be closed by merging the pull request.

## Examples

``` r
if (FALSE) { # interactive()

  # You must have at least one pull request open in the GitHub repository
  # associated with the current git repository for this to return any
  # results.
  QCPR()
}
```
