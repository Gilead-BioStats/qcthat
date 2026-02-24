# Check whether an issue closer originates from the target repository

Check whether an issue closer originates from the target repository

## Usage

``` r
IsIssueCloserFromRepo(lIssueCloser, strNameWithOwner)
```

## Arguments

- lIssueCloser:

  (`list`) A single raw issue node.

- strNameWithOwner:

  (`character(1)`) `"owner/repo"` of the target repo.

## Value

A length-1 `logical`.
