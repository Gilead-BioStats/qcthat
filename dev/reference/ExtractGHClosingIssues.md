# Extract closing issue numbers from commit messages

Extract closing issue numbers from commit messages

## Usage

``` r
ExtractGHClosingIssues(
  chrCommitMessages,
  chrKeywords = c("close", "closes", "closed", "fix", "fixes", "fixed", "resolve",
    "resolves", "resolved"),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]]
)
```

## Arguments

- chrKeywords:

  (`character`) Keywords to search for just before issue numbers in
  commit messages. Defaults to the [GitHub issue-linking
  keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

## Value

An integer vector of issue numbers found in `chrCommitMessages` that
will be closed according to GitHub's keywords for linking issues to pull
requests.
