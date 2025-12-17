# Parameters used in multiple functions

Reused parameter definitions are gathered here for easier usage. Use
`@inheritParams shared-params` to document parameters defined here.

## Arguments

- chrChecks:

  (`character`) Items for the user to check. These will be preceded by
  checkboxes in the associated issue.

- chrClass:

  (`character`) Class name(s) to assign to the object.

- chrCommitSHAs:

  (`character`) SHAs of git commits.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- chrInstructions:

  (`character`) Instructions for how to review an issue. Included in the
  associated issue before the checklist.

- chrKeywords:

  (`character`) Keywords to search for just before issue numbers in
  commit messages. Defaults to the [GitHub issue-linking
  keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)

- chrLabels:

  (`character`) The name(s) of labels(s) to use.

- chrMilestones:

  (`character`) The name(s) of milestone(s) to filter issues by.

- chrSourcePath:

  (`character`) Components of a path to a source file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- chrTargetPath:

  (`character`) Components of a path to a target file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- chrTests:

  (`character`) A vector of test descriptions from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  matrix.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsIssueTestMatrix.md).

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

- envErrorMessage:

  (`environment`) The environment to pass to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html) to
  resolve variables.

- fctDisposition:

  (`factor`) Disposition factor with levels `c("fail", "skip", "pass")`.

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- intIssues:

  (`integer`) A vector of issue numbers from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  matrix or from GitHub.

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

- intParentIssue:

  (`length-1 integer`) The number of an issue to which a child issue
  will attach.

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about.

- intPRNumbers:

  (`integer`) A vector of pull request numbers.

- lCommentsRaw:

  (`list`) List of raw comment objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

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

- lglShowIgnoredLabels:

  (`length-1 logical`) Whether to show information in reports about
  issue labels (such as `"qcthat-nocov"`) that have been ignored.

- lglUseEmoji:

  (`length-1 logical`) Whether to use emojis (if `TRUE` and the emoji
  package is installed) or ASCII indicators (if `FALSE`) in the output.
  By default, this is determined by the `qcthat.emoji` option, which
  defaults to `TRUE`.

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- objShape:

  (`0-row data.frame`, etc) Object with the expected structure.

- strBody:

  (`length-1 character`) The body of an issue, PR, or comment, in GitHub
  markdown.

- strBodyCompiled:

  (`length-1 character`) The full body of an issue, PR, or comment, in
  GitHub markdown, including components such as a title and a hidden
  `qcthat-comment-id`.

- strChildIssueID:

  (`length-1 character`) The `id` field of an issue to connect to a
  parent issue.

- strCommentID:

  (`length-1 character`) A unique ID for a comment within a given
  context, which is usually a hash of the title of the comment.

- strConditionSubclass:

  (`length-1 character`) A subclass for a condition.

- strConditionClass:

  (`length-1 character`) One of "error", "warning", or "message".

- strErrorSubclass:

  (`length-1 character`) A subclass for an error condition.

- strErrorMessage:

  (`length-1 character`) A message to include in and error report. Can
  include
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html)
  syntax.

- strExtension:

  (`length-1 character`) The file extension to use for the target file.
  If the target path already includes an extension, it will be replaced
  with this value. If the value is already correct, this won't have any
  effect.

- strFailureMode:

  (`length-1 character`) Whether to `"ignore"` failures (default) or
  `"fail"` (and show as a failure in testthat tests).

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strRepo:

  (`length-1 character`) GitHub repository name.

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

- strState:

  (`length-1 character`) State of issues or pull requests to fetch. Must
  be one of `"open"`, `"closed"`, or `"all"`. Defaults to `"open"` for
  pull requests and `"all"` for issues.

- strTargetRef:

  (`length-1 character`) Name of the git reference that will be merged
  into. Defaults to the default branch of this repository.

- strTitle:

  (`length-1 character`) A title for an issue.
