# Install a skill from qcthat into a package repo

Install a skill from qcthat into a package repo

## Usage

``` r
InstallSkill(
  strSkillName,
  strTargetDir = ".github/skills",
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
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

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The path to the created skill file (invisibly).
