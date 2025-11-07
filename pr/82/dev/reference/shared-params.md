# Parameters used in multiple functions

Reused parameter definitions are gathered here for easier usage. Use
`@inheritParams shared-params` to document parameters defined here.

## Arguments

- chrClass:

  (`character`) Class name(s) to assign to the object.

- chrSourcePath:

  (`character`) Components of a path to a source file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- chrTargetPath:

  (`character`) Components of a path to a target file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- dfRepoIssues:

  (`qcthat_Issues` or data frame) Data frame of GitHub issues as
  returned by
  [`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssues.md).

- dfTestResults:

  (`qcthat_TestResults` or data frame) Data frame of test results as
  returned by
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

- fctDisposition:

  (`factor`) Disposition factor with levels `c("fail", "skip", "pass")`.

- lIssuesNonPR:

  (`list`) List of issue objects as returned by
  [`RemovePRsFromIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/RemovePRsFromIssues.md).

- lTestResults:

  (`testthat_results`) A testthat test results object, typically
  obtained by running something like
  [`testthat::test_local()`](https://testthat.r-lib.org/reference/test_package.html)
  with `stop_on_failure = FALSE` and a reporter that doesn't cause
  issues in parallel testing, like `reporter = "silent"`, and assigning
  it to a name.

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- lglShowMilestones:

  (`length-1 logical`) Whether to separate issues by milestones in
  reports.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

- objShape:

  (`0-row data.frame`, etc) Object with the expected structure.

- strExtension:

  (`length-1 character`) The file extension to use for the target file.
  If the target path already includes an extension, it will be replaced
  with this value. If the value is already correct, this won't have any
  effect.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strPkgRoot:

  (`length-1 character`) The path to the root directory of the package.
  Will be expanded using
  [`pkgload::pkg_path()`](https://pkgload.r-lib.org/reference/packages.html).

- strRepo:

  (`length-1 character`) GitHub repository name.
