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
  strPkgRoot = ".",
  strOwner = gh::gh_tree_remote(strPkgRoot)[["username"]],
  strRepo = gh::gh_tree_remote(strPkgRoot)[["repo"]],
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels()
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

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

## Value

A `qcthat_IssueTestMatrix` object as returned by
[`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md),
filtered to issues that will be closed by merging the pull request.

## See also

[`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/reference/QCMergeLocal.md)
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
