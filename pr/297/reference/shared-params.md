# Parameters used in multiple functions

Reused parameter definitions are gathered here for easier usage. Use
`@inheritParams shared-params` to document parameters defined here.

## Arguments

- chrAssignees:

  (`character`) GitHub usernames to which the issue associated with an
  expectation should be assigned. Whenever the issue is assigned to a
  new user, it will be re-opened. Elements of this vector will be split
  on commas, so you can provide multiple assignees in a single string.
  This is helpful if you would like to set up assignees via the
  `"qcthat_UAT_ASSIGNEES"` environment variable, which is checked by
  default.

- chrChecks:

  (`character`) Items for the user to check. These will be preceded by
  checkboxes in the associated issue.

- chrClass:

  (`character`) Class name(s) to assign to the object.

- chrCommitSHAs:

  (`character`) SHAs of git commits.

- chrErrorMessage:

  (`character`) A message to include in an error report. Can include
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html)
  syntax. Formatted via
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

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

- chrTestLines:

  (`character`) Vector of lines from a test file.

- chrTests:

  (`character`) A vector of test descriptions from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/CompileIssueTestMatrix.md)
  matrix or extracted from test files.

- dttmTimestamp:

  (`POSIXct`) A system timestamp.

- dfFileTests:

  (`data.frame`) A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with the structure returned by
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/reference/ExtractTestsFromFiles.md).

- dfIssueCommitsLong:

  (`data.frame` or `NULL`) Pre-computed issue-commit mappings from
  [`MapLongIssueCommits()`](https://gilead-biostats.github.io/qcthat/reference/MapLongIssueCommits.md).
  If `NULL` (the default), fetched automatically from the GitHub API.
  Provide this when calling
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md)
  multiple times to avoid redundant API requests.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md)).

- dfLabels:

  (`data.frame`) A data frame with columns `Label`, `Description`, and
  `Color`, specifying the labels to create. By default, this is the data
  frame returned by
  [`DefaultIgnoreLabelsDF()`](https://gilead-biostats.github.io/qcthat/reference/DefaultIgnoreLabelsDF.md).
  Descriptions of labels created via this function are prefixed with
  `"{qcthat}: "` to make it easier to search for them in your list of
  labels.

- dfPotentialIssues:

  (`tibble`) A data frame as returned by
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/reference/MapTestFilesToPotentialIssues.md).

- dfRepoIssues:

  (`qcthat_Issues` or data frame) Data frame of GitHub issues as
  returned by
  [`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/reference/FetchRepoIssues.md).

- dfTestResults:

  (`qcthat_TestResults` or data frame) Data frame of test results as
  returned by
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/reference/CompileTestResults.md).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

- envErrorMessage:

  (`environment`) The environment to pass to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html) to
  resolve variables.

- envPkg:

  (`environment`) A loaded package environment, as returned by
  [`LoadPkgEnv()`](https://gilead-biostats.github.io/qcthat/reference/LoadPkgEnv.md).

- fctDisposition:

  (`factor`) Disposition factor with levels `"fail"`, `"warn"`,
  `"skip"`, and `"pass"`.

- intIssue:

  (`length-1 integer`) The issue with which a check is associated.

- intIssues:

  (`integer`) A vector of issue numbers from a
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/CompileIssueTestMatrix.md)
  matrix or from GitHub.

- intLineEnd:

  (`length-1 integer`) The ending line number.

- intLineStart:

  (`length-1 integer`) The starting line number.

- intMaxCommits:

  (`length-1 integer`) The maximum number of commits to return from git
  logs. Leaving this at the default should almost always be fine, but
  you can reduce the number if your repository has a long commit history
  and this function is slow.

- intPageMax:

  (`length-1 integer`) The maximum number of pages of commits to fetch
  from the GitHub API. Each page contains up to 100 commits. Defaults to
  100, which fetches up to 10,000 commits. You likely never need to
  increase this number, but try a larger number if a merge involves a
  very large number of commits in a very large repository.

- intParentIssue:

  (`length-1 integer`) The number of the parent issue in a parent-child
  issue relationship.

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

- intPRNumbers:

  (`integer`) A vector of pull request numbers.

- intTestStart:

  (`length-1 integer`) Line number where test_that starts.

- intUATIssue:

  (`integer`) The number of an issue that tracks user-acceptance
  testing.

- lCommentsRaw:

  (`list`) List of raw comment objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

- lGHEventPayload:

  (`list`) The GitHub event payload. Defaults to the result of
  [`LoadGHEventPayload()`](https://gilead-biostats.github.io/qcthat/reference/LoadGHEventPayload.md).

- lIssuesNonPR:

  (`list`) List of issue objects as returned by
  [`RemovePRsFromIssues()`](https://gilead-biostats.github.io/qcthat/reference/RemovePRsFromIssues.md).

- lTestResults:

  (`testthat_results`) A testthat test results object, typically
  obtained by running something like
  [`testthat::test_local()`](https://testthat.r-lib.org/reference/test_package.html)
  with `stop_on_failure = FALSE` and a reporter that doesn't cause
  issues in parallel testing, like `reporter = "silent"`, and assigning
  it to a name.

- lPRActionRuns:

  (`list`) A list of workflow run objects as returned by GitHub.

- lglCompleted:

  (`length-1 logical`) Whether to include the
  [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/reference/QCCompletedIssues.md)
  report.

- lglMilestone:

  (`length-1 logical`) Whether to include the
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/reference/QCMilestones.md)
  report.

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- lglPR:

  (`length-1 logical`) Whether to include the
  [`QCPR()`](https://gilead-biostats.github.io/qcthat/reference/QCPR.md)
  report.

- lglReportFailure:

  (`length-1 logical`) Whether to ignore failures (default unless a
  "qcthat_UAT" environment variable is "true"), or fail (and show as a
  failure in testthat tests).

- lglShowMilestones:

  (`length-1 logical`) Whether to separate issues by milestones in
  reports.

- lglShowIgnoredLabels:

  (`length-1 logical`) Whether to show information in reports about
  issue labels (such as `"qcthat-nocov"`) that have been ignored.

- lglUAT:

  (`length-1 logical`) Whether to include the
  [`CommentUAT()`](https://gilead-biostats.github.io/qcthat/reference/CommentUAT.md)
  report.

- lglUpdate:

  (`length-1 logical`) Whether to update an existing comment or label if
  it already exists (rather than creating a new comment or label).

- lglUseCoverage:

  (`length-1 logical`) Whether to augment potential issues with
  source-line coverage. When `TRUE`,
  [`covr::environment_coverage()`](http://covr.r-lib.org/reference/environment_coverage.md)
  is used to discover issues from commits that touched source code
  exercised by each test. Requires `covr` to be installed. Defaults to
  `FALSE`.

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

  (`length-1 character`) The body of an issue, PR, comment, or release,
  in GitHub markdown.

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

- strCommitSHA:

  (`length-1 character`) The commit SHA to target.

- strConditionSubclass:

  (`length-1 character`) A subclass for a condition.

- strConditionClass:

  (`length-1 character`) One of "error", "warning", or "message".

- strDescription:

  (`length-1 character`) A brief description of a user expectation.

- strDirPath:

  (`length-1 character`) The path to a directory.

- strDisposition:

  (`length-1 character`) The result of a test, such as "pass", "fail",
  "warn", or "skip", or "accepted" or "pending" for UAT.

- strErrorSubclass:

  (`length-1 character`) A subclass for an error condition.

- strExtension:

  (`length-1 character`) The file extension to use for the target file.
  If the target path already includes an extension, it will be replaced
  with this value. If the value is already correct, this won't have any
  effect.

- strFile:

  (`length-1 character`) A file name without the path.

- strFilePath:

  (`length-1 character`) A file path.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

- strLabel:

  (`length-1 character`) The name of the label to create or update.

- strLabelColor:

  (`length-1 character`) The hex color code for the label (e.g.,
  `"#444444"`).

- strLabelDescription:

  (`length-1 character`) The description for the label.

- strLabelNewName:

  (`length-1 character`) The new name for an updated label.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strPRHeadRef:

  (`length-1 character`) The branch name (head ref) of the PR.

- strReleaseID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub release.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strReportType:

  (`length-1 character`) The main title of the report, such as
  `"Completed Issues"` or `"PR-Associated Issues"`.

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strSourceRef:

  (`length-1 character`) Name of the git reference that contains
  changes. Defaults to the active branch in this repository.

- strState:

  (`length-1 character`) State of issues or pull requests to fetch. Must
  be one of `"open"`, `"closed"`, or `"all"`. Defaults to `"open"` for
  pull requests and `"all"` for issues.

- strStateReason:

  (`length-1 character`) The reason for the state change (for `"closed"`
  `strState`). Must be one of `"completed"`, `"not_planned"`,
  `"duplicate"`, `"reopened."`, or `NULL`.

- strTagName:

  (`length-1 character`) Name of the GitHub tag.

- strTargetDir:

  (`length-1 character`) Path to the directory where the file should be
  added.

- strTargetRef:

  (`length-1 character`) Name of the git reference that will be merged
  into. Defaults to the default branch of this repository.

- strTestDir:

  (`length-1 character`) Path to the directory containing test files.
  Defaults to `"tests/testthat"`.

- strTitle:

  (`length-1 character`) A title for an issue.
