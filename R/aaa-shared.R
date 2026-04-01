#' Parameters used in multiple functions
#'
#' Reused parameter definitions are gathered here for easier usage. Use
#' `@inheritParams shared-params` to document parameters defined here.
#'
#' @param chrAssignees (`character`) GitHub usernames to which the issue
#'   associated with an expectation should be assigned. Whenever the issue is
#'   assigned to a new user, it will be re-opened. Elements of this vector will
#'   be split on commas, so you can provide multiple assignees in a single
#'   string. This is helpful if you would like to set up assignees via the
#'   `"qcthat_UAT_ASSIGNEES"` environment variable, which is checked by default.
#' @param chrChecks (`character`) Items for the user to check. These will be
#'   preceded by checkboxes in the associated issue.
#' @param chrClass (`character`) Class name(s) to assign to the object.
#' @param chrCommitSHAs (`character`) SHAs of git commits.
#' @param chrErrorMessage (`character`) A message to include in an error report.
#'   Can include [glue::glue()] syntax. Formatted via [cli::cli_bullets()].
#' @param chrIgnoredLabels (`character`) GitHub labels to ignore, such as
#'   `"qcthat-nocov"`.
#' @param chrInstructions (`character`) Instructions for how to review an issue.
#'   Included in the associated issue before the checklist.
#' @param chrKeywords (`character`) Keywords to search for just before issue
#'   numbers in commit messages. Defaults to the [GitHub issue-linking
#'   keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)
#' @param chrLabels (`character`) The name(s) of labels(s) to use.
#' @param chrMilestones (`character`) The name(s) of milestone(s) to filter
#'   issues by.
#' @param chrSourcePath (`character`) Components of a path to a source file. The
#'   file extension should be included in the filename or omitted (NOT sent as a
#'   separate piece of the vector).
#' @param chrTargetPath (`character`) Components of a path to a target file. The
#'   file extension should be included in the filename or omitted (NOT sent as a
#'   separate piece of the vector).
#' @param chrTestLines (`character`) Vector of lines from a test file.
#' @param chrTests (`character`) A vector of test descriptions from a
#'   [CompileIssueTestMatrix()] matrix or extracted from test files.
#' @param dttmTimestamp (`POSIXct`) A system timestamp.
#' @param dfFileTests (`data.frame`) A [tibble::tibble()] with the structure
#'   returned by [ExtractTestsFromFiles()].
#' @param dfIssueCommitsLong (`data.frame` or `NULL`) Pre-computed issue-commit
#'   mappings from [MapLongIssueCommits()]. If `NULL` (the default), fetched
#'   automatically from the GitHub API. Provide this when calling
#'   [MapTestFilesToPotentialIssues()] multiple times to avoid redundant API
#'   requests.
#' @param dfITM (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
#'   returned by [AsIssueTestMatrix()] (often via [QCPackage()]).
#' @param dfLabels (`data.frame`) A data frame with columns `Label`,
#'   `Description`, and `Color`, specifying the labels to create. By default,
#'   this is the data frame returned by [DefaultIgnoreLabelsDF()]. Descriptions
#'   of labels created via this function are prefixed with `"{qcthat}: "` to
#'   make it easier to search for them in your list of labels.
#' @param dfPotentialIssues (`tibble`) A data frame as returned by
#'   [MapTestFilesToPotentialIssues()].
#' @param dfRepoIssues (`qcthat_Issues` or data frame) Data frame of GitHub
#'   issues as returned by [FetchRepoIssues()].
#' @param dfTestResults (`qcthat_TestResults` or data frame) Data frame of test
#'   results as returned by [CompileTestResults()].
#' @param envCall (`environment`) The environment to use for error reporting.
#'   Typically set to [rlang::caller_env()].
#' @param envErrorMessage (`environment`) The environment to pass to
#'   [glue::glue()] to resolve variables.
#' @param envPkg (`environment`) A loaded package environment, as returned by
#'   [LoadPkgEnv()].
#' @param fctDisposition (`factor`) Disposition factor with levels `"fail"`,
#'   `"warn"`, `"skip"`, and `"pass"`.
#' @param intIssue (`length-1 integer`) The issue with which a check is
#'   associated.
#' @param intIssues (`integer`) A vector of issue numbers from a
#'   [CompileIssueTestMatrix()] matrix or from GitHub.
#' @param intLineEnd (`length-1 integer`) The ending line number.
#' @param intLineStart (`length-1 integer`) The starting line number.
#' @param intMaxCommits (`length-1 integer`) The maximum number of commits to
#'   return from git logs. Leaving this at the default should almost always be
#'   fine, but you can reduce the number if your repository has a long commit
#'   history and this function is slow.
#' @param intPageMax (`length-1 integer`) The maximum number of pages of commits
#'   to fetch from the GitHub API. Each page contains up to 100 commits.
#'   Defaults to 100, which fetches up to 10,000 commits. You likely never need
#'   to increase this number, but try a larger number if a merge involves a very
#'   large number of commits in a very large repository.
#' @param intParentIssue (`length-1 integer`) The number of the parent issue in
#'   a parent-child issue relationship.
#' @param intPRNumber (`length-1 integer`) The number of the pull request to
#'   fetch information about and/or post results to.
#' @param intPRNumbers (`integer`) A vector of pull request numbers.
#' @param intTestStart (`length-1 integer`) Line number where test_that starts.
#' @param intUATIssue (`integer`) The number of an issue that tracks
#'   user-acceptance testing.
#' @param lCommentsRaw (`list`) List of raw comment objects as returned by
#'   [gh::gh()].
#' @param lGHEventPayload (`list`) The GitHub event payload. Defaults to the
#'   result of [LoadGHEventPayload()].
#' @param lIssuesNonPR (`list`) List of issue objects as returned by
#'   [RemovePRsFromIssues()].
#' @param lTestResults (`testthat_results`) A testthat test results object,
#'   typically obtained by running something like [testthat::test_local()] with
#'   `stop_on_failure = FALSE` and a reporter that doesn't cause issues in
#'   parallel testing, like `reporter = "silent"`, and assigning it to a name.
#' @param lPRActionRuns (`list`) A list of workflow run objects as returned by
#'   GitHub.
#' @param lglCompleted (`length-1 logical`) Whether to include the
#'   [QCCompletedIssues()] report.
#' @param lglMilestone (`length-1 logical`) Whether to include the
#'   [QCMilestones()] report.
#' @param lglOverwrite (`length-1 logical`) Whether to overwrite files if they
#'   already exist.
#' @param lglPR (`length-1 logical`) Whether to include the [QCPR()] report.
#' @param lglReportFailure (`length-1 logical`) Whether to ignore failures
#'   (default unless a "qcthat_UAT" environment variable is "true"), or fail
#'   (and show as a failure in testthat tests).
#' @param lglShowMilestones (`length-1 logical`) Whether to separate issues by
#'   milestones in reports.
#' @param lglShowIgnoredLabels (`length-1 logical`) Whether to show information
#'   in reports about issue labels (such as `"qcthat-nocov"`) that have been
#'   ignored.
#' @param lglUAT (`length-1 logical`) Whether to include the [CommentUAT()]
#'   report.
#' @param lglUpdate (`length-1 logical`) Whether to update an existing comment
#'   or label if it already exists (rather than creating a new comment or
#'   label).
#' @param lglUseCoverage (`length-1 logical`) Whether to augment potential
#'   issues with source-line coverage. When `TRUE`,
#'   [covr::environment_coverage()] is used to discover issues from commits that
#'   touched source code exercised by each test. Requires `covr` to be
#'   installed. Defaults to `FALSE`.
#' @param lglUseEmoji (`length-1 logical`) Whether to use emojis (if `TRUE` and
#'   the emoji package is installed) or ASCII indicators (if `FALSE`) in the
#'   output. By default, this is determined by the `qcthat.emoji` option, which
#'   defaults to `TRUE`.
#' @param lglWarn (`length-1 logical`) Whether to warn when an extra value is
#'   included in the filter (but the report still returns results). Defaults to
#'   `TRUE`.
#' @param objShape (`0-row data.frame`, etc) Object with the expected structure.
#' @param strBody (`length-1 character`) The body of an issue, PR, comment, or
#'   release, in GitHub markdown.
#' @param strBodyCompiled (`length-1 character`) The full body of an issue, PR,
#'   or comment, in GitHub markdown, including components such as a title and a
#'   hidden `qcthat-comment-id`.
#' @param strChildIssueID (`length-1 character`) The `id` field of an issue to
#'   connect to a parent issue.
#' @param strCommentID (`length-1 character`) A unique ID for a comment within a
#'   given context, which is usually a hash of the title of the comment.
#' @param strCommitSHA (`length-1 character`) The commit SHA to target.
#' @param strConditionSubclass (`length-1 character`) A subclass for a
#'   condition.
#' @param strConditionClass (`length-1 character`) One of "error", "warning", or
#'   "message".
#' @param strDescription (`length-1 character`) A brief description of a user
#'   expectation.
#' @param strDirPath (`length-1 character`) The path to a directory.
#' @param strDisposition (`length-1 character`) The result of a test, such as
#'   "pass", "fail", "warn", or "skip", or "accepted" or "pending" for UAT.
#' @param strErrorSubclass (`length-1 character`) A subclass for an error
#'   condition.
#' @param strExtension (`length-1 character`) The file extension to use for the
#'   target file. If the target path already includes an extension, it will be
#'   replaced with this value. If the value is already correct, this won't have
#'   any effect.
#' @param strFile (`length-1 character`) A file name without the path.
#' @param strFilePath (`length-1 character`) A file path.
#' @param strGHToken (`length-1 character`) GitHub token with permissions
#'   appropriate to the action being performed.
#' @param strLabel (`length-1 character`) The name of the label to create or
#'   update.
#' @param strLabelColor (`length-1 character`) The hex color code for the label
#'   (e.g., `"#444444"`).
#' @param strLabelDescription (`length-1 character`) The description for the
#'   label.
#' @param strLabelNewName (`length-1 character`) The new name for an updated
#'   label.
#' @param strOwner (`length-1 character`) GitHub username or organization name.
#' @param strPkgRoot (`length-1 character`) The path to a directory in the
#'   package. Will be expanded using [gert::git_find()].
#' @param strPRHeadRef (`length-1 character`) The branch name (head ref) of the
#'   PR.
#' @param strReleaseID (`length-1 character`) ID (typically numeric but can be
#'   very long) of a GitHub release.
#' @param strRepo (`length-1 character`) GitHub repository name.
#' @param strReportType (`length-1 character`) The main title of the report,
#'   such as `"Completed Issues"` or `"PR-Associated Issues"`.
#' @param strRunID (`length-1 character`) ID (typically numeric but can be very
#'   long) of a GitHub Actions workflow run.
#' @param strSourceRef (`length-1 character`) Name of the git reference that
#'   contains changes. Defaults to the active branch in this repository.
#' @param strState (`length-1 character`) State of issues or pull requests to
#'   fetch. Must be one of `"open"`, `"closed"`, or `"all"`. Defaults to
#'   `"open"` for pull requests and `"all"` for issues.
#' @param strStateReason (`length-1 character`) The reason for the state change
#'   (for `"closed"` `strState`). Must be one of `"completed"`, `"not_planned"`,
#'   `"duplicate"`, `"reopened."`, or `NULL`.
#' @param strTagName (`length-1 character`) Name of the GitHub tag.
#' @param strTargetDir (`length-1 character`) Path to the directory where the
#'   file should be added.
#' @param strTargetRef (`length-1 character`) Name of the git reference that
#'   will be merged into. Defaults to the default branch of this repository.
#' @param strTestDir (`length-1 character`) Path to the directory containing
#'   test files. Defaults to `"tests/testthat"`.
#' @param strTitle (`length-1 character`) A title for an issue.
#'
#' @name shared-params
#' @keywords internal
NULL
