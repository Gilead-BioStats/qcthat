# Compile the regex used to find GitHub-closing issues in commit messages

Compile the regex used to find GitHub-closing issues in commit messages

## Usage

``` r
GHKeywordRegex(
  chrKeywords = c("close", "closes", "closed", "fix", "fixes", "fixed", "resolve",
    "resolves", "resolved"),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo()
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

A length-1 character vector containing the regex pattern.
