# Use an AI skill to tag tests with issues

Install an AI skill into a package repository to help identify and tag
tests with their related GitHub issues. The skill guides the process of
connecting test cases to the features or bugs they address by adding
issue references (e.g., `(#123)`) to test descriptions.

## Usage

``` r
Skill_TagTestsWithIssues(
  strTargetDir = ".github/skills",
  lglOverwrite = FALSE,
  strPkgRoot = "."
)
```

## Arguments

- strTargetDir:

  (`length-1 character`) Path to the directory where the file should be
  added.

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

## Value

The path to the created skill file (invisibly).

## Examples

``` r
if (FALSE) { # interactive()

  Skill_TagTestsWithIssues()
}
```
