# Find issues that will be closed by merging one branch into another

Find issues that will be closed by merging one branch into another

## Usage

``` r
FindKeywordIssues(
  strSourceRef = GetActiveBranch(strPkgRoot),
  strTargetRef = GetDefaultBranch(strPkgRoot),
  strPkgRoot = ".",
  chrKeywords = c("close", "closes", "closed", "fix", "fixes", "fixed", "resolve",
    "resolves", "resolved"),
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
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

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- chrKeywords:

  (`character`) Keywords to search for just before issue numbers in
  commit messages. Defaults to the [GitHub issue-linking
  keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

## Value

An integer vector of issue numbers in this repo that will be closed by
merging `strSourceRef` into `strTargetRef`, using the [GitHub keywords
for linking issues to pull
requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword).
