# Changelog

## qcthat 1.1.2

This patch release focuses on introducing the world to qcthat.

### Documentation improvements

- Two new vignettes have been added,
  [`vignette("qcthat")`](https://gilead-biostats.github.io/qcthat/dev/articles/qcthat.md)
  and
  [`vignette("business_process")`](https://gilead-biostats.github.io/qcthat/dev/articles/business_process.md).
  They were split off and refined from information that was previously
  in the README
  ([\#98](https://github.com/Gilead-BioStats/qcthat/issues/98),
  [\#236](https://github.com/Gilead-BioStats/qcthat/issues/236)).
- The slide deck on the pkgdown site has been finalized ahead of PHUSE
  US Connect 2026
  ([\#170](https://github.com/Gilead-BioStats/qcthat/issues/170)).

### Bug fixes

- Warnings in tests now produce warnings rather than errors
  ([\#130](https://github.com/Gilead-BioStats/qcthat/issues/130)).
- Tests are no longer double-counted when they are associated with
  multiple issues
  ([\#180](https://github.com/Gilead-BioStats/qcthat/issues/180)).

## qcthat 1.1.1

This patch release contains improvements and bug fixes discovered while
applying the experimental AI agent features released in qcthat v1.1.0.
These changes are tracked in
[\#241](https://github.com/Gilead-BioStats/qcthat/issues/241).

### New features

- The experimental `tag-tests-with-issues` skill now generates a report
  in `pkgdown/assets` describing the reasons that tests were tagged with
  each issue. If the pkgdown uses pkgdown, this report will be available
  at `{pkgdown_root}/test_tag_reasons.html`. We recommend using this
  report locally to verify results, and then deleting the report without
  merging it into your pkgdown site
  ([\#242](https://github.com/Gilead-BioStats/qcthat/issues/242)).

### Bug fixes

- [`FetchRepoIssueClosers()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssueClosers.md)
  is now better at determining which pull request or merge caused each
  issue to be closed. Other portions of the issue-test relationship
  mechanism are properly fetched from GitHub (in case the local repo
  does not have all changes), but the fetches are now much more
  optimized
  ([\#243](https://github.com/Gilead-BioStats/qcthat/issues/243),
  [\#251](https://github.com/Gilead-BioStats/qcthat/issues/251)).
- [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md)
  now uses a much more robust mechanism to quickly parse tests, built
  with the {astgrepr} R package
  ([\#247](https://github.com/Gilead-BioStats/qcthat/issues/247),
  [\#257](https://github.com/Gilead-BioStats/qcthat/issues/257)).
- [`GetGHRemote()`](https://gilead-biostats.github.io/qcthat/dev/reference/GetGHRemote.md)
  no longer truncates the repo name for repositories with a `.` in the
  name (such as “gsm.reporting”)
  ([\#248](https://github.com/Gilead-BioStats/qcthat/issues/248)).
- The `qcthat.yaml` workflow no longer erroneously mentions “push”
  triggers
  ([\#259](https://github.com/Gilead-BioStats/qcthat/issues/259)).

## qcthat 1.1.0

New features and tools to help you track user acceptance testing, and to
help you use AI agents to get started with `qcthat`.

### New features

Experimental functions for tracking user-acceptance testing (UAT):

- [`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExpectUserAccepts.md)
  enables tracking of user acceptance by connecting `testthat` tests to
  GitHub issues. Once the UAT issue is closed, the test will pass
  ([\#65](https://github.com/Gilead-BioStats/qcthat/issues/65),
  [\#111](https://github.com/Gilead-BioStats/qcthat/issues/111),
  [\#113](https://github.com/Gilead-BioStats/qcthat/issues/113),
  [\#115](https://github.com/Gilead-BioStats/qcthat/issues/115),
  [\#120](https://github.com/Gilead-BioStats/qcthat/issues/120)).
- [`TriggerUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/TriggerUAT.md)
  triggers the UAT test cycle for a closed issue. This function is used
  by the improved GitHub Actions framework, installable via
  [`Action_qcthat()`](https://gilead-biostats.github.io/qcthat/dev/reference/Action_qcthat.md)
  ([\#65](https://github.com/Gilead-BioStats/qcthat/issues/65),
  [\#111](https://github.com/Gilead-BioStats/qcthat/issues/111),
  [\#114](https://github.com/Gilead-BioStats/qcthat/issues/114),
  [\#115](https://github.com/Gilead-BioStats/qcthat/issues/115),
  [\#116](https://github.com/Gilead-BioStats/qcthat/issues/116),
  [\#157](https://github.com/Gilead-BioStats/qcthat/issues/157)).

Improved onboarding:

- [`use_qcthat()`](https://gilead-biostats.github.io/qcthat/dev/reference/use_qcthat.md)
  calls
  [`SetupGHLabels()`](https://gilead-biostats.github.io/qcthat/dev/reference/SetupGHLabels.md)
  and
  [`Action_qcthat()`](https://gilead-biostats.github.io/qcthat/dev/reference/Action_qcthat.md),
  to set up your repository with GitHub Actions workflows and labels
  used for QC tracking
  ([\#129](https://github.com/Gilead-BioStats/qcthat/issues/129),
  [\#141](https://github.com/Gilead-BioStats/qcthat/issues/141),
  [\#143](https://github.com/Gilead-BioStats/qcthat/issues/143),
  [\#161](https://github.com/Gilead-BioStats/qcthat/issues/161),
  [\#165](https://github.com/Gilead-BioStats/qcthat/issues/165),
  [\#181](https://github.com/Gilead-BioStats/qcthat/issues/181),
  [\#198](https://github.com/Gilead-BioStats/qcthat/issues/198)).
- Experimental AI agent features:
  [`Skill_TagTestsWithIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/Skill_TagTestsWithIssues.md)
  installs an AI agent skill to tag tests with issues, using new
  functions
  [`ExtractTestsFromFiles()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md),
  [`MapTestFilesToPotentialIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/MapTestFilesToPotentialIssues.md),
  and
  [`PrepareTestIssueContext()`](https://gilead-biostats.github.io/qcthat/dev/reference/PrepareTestIssueContext.md)
  ([\#52](https://github.com/Gilead-BioStats/qcthat/issues/52),
  [\#53](https://github.com/Gilead-BioStats/qcthat/issues/53),
  [\#200](https://github.com/Gilead-BioStats/qcthat/issues/200),
  [\#201](https://github.com/Gilead-BioStats/qcthat/issues/201),
  [\#233](https://github.com/Gilead-BioStats/qcthat/issues/233)).

### Other changes

- Additional improvements to QC reports, such as links to the GitHub
  Actions run
  ([\#150](https://github.com/Gilead-BioStats/qcthat/issues/150)),
  timestamps
  ([\#172](https://github.com/Gilead-BioStats/qcthat/issues/172)), and
  attaching QC Reports to releases within the release description
  ([\#152](https://github.com/Gilead-BioStats/qcthat/issues/152)).
  Additional changes are tracked in the parent issues
  ([\#123](https://github.com/Gilead-BioStats/qcthat/issues/123),
  [\#160](https://github.com/Gilead-BioStats/qcthat/issues/160)).
- The `pkgdown` site for `qcthat` now includes a slide deck to introduce
  the package and the associated system
  ([\#166](https://github.com/Gilead-BioStats/qcthat/issues/166),
  [\#167](https://github.com/Gilead-BioStats/qcthat/issues/167),
  [\#168](https://github.com/Gilead-BioStats/qcthat/issues/168),
  [\#169](https://github.com/Gilead-BioStats/qcthat/issues/169)).

### Bug fixes

- Ignored issues are filtered out of reports
  ([\#118](https://github.com/Gilead-BioStats/qcthat/issues/118)).
- Reports work properly when the active branch is associated with
  multiple PRs
  ([\#132](https://github.com/Gilead-BioStats/qcthat/issues/132)), when
  the PRs contain a lot of commits
  ([\#133](https://github.com/Gilead-BioStats/qcthat/issues/133)), and
  after PRs are merged
  ([\#149](https://github.com/Gilead-BioStats/qcthat/issues/149)).
- [`GetGHOwner()`](https://gilead-biostats.github.io/qcthat/dev/reference/GetGHOwner.md)
  and
  [`GetGHRepo()`](https://gilead-biostats.github.io/qcthat/dev/reference/GetGHRepo.md)
  should now work for forks, even if the local repo name does not match
  the upstream repo name
  ([\#199](https://github.com/Gilead-BioStats/qcthat/issues/199)).

## qcthat 1.0.0

You can now use this package to implement a QC framework for any R
package associated with a GitHub repository.

### New features

A series of `QC*()` functions to generate QC reports for different sets
of issues:

- [`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)
  for all issues and tests for an R package and its associated GitHub
  repository
  ([\#46](https://github.com/Gilead-BioStats/qcthat/issues/46),
  [\#69](https://github.com/Gilead-BioStats/qcthat/issues/69)).
- [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCCompletedIssues.md)
  for only issues closed as completed
  ([\#69](https://github.com/Gilead-BioStats/qcthat/issues/69),
  [\#80](https://github.com/Gilead-BioStats/qcthat/issues/80)).
- [`QCIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCIssues.md)
  for specific issues
  ([\#86](https://github.com/Gilead-BioStats/qcthat/issues/86)), and
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMilestones.md)
  for issues associated with specific named milestones
  ([\#68](https://github.com/Gilead-BioStats/qcthat/issues/68),
  [\#88](https://github.com/Gilead-BioStats/qcthat/issues/88))
- [`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md)
  for issues associated with specific GitHub pull requests,
  [`QCMergeGH()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeGH.md)
  to generalize to issues associated with any GitHub merge using
  GitHub’s graph to determine connections, and
  [`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMergeLocal.md)
  to detect probable associations based on commit messages
  ([\#68](https://github.com/Gilead-BioStats/qcthat/issues/68),
  [\#84](https://github.com/Gilead-BioStats/qcthat/issues/84)).

A series of `Action_*()` functions to set up GitHub actions for QC
reports:

- `Action_QCCompletedIssues()` to run
  [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCCompletedIssues.md)
  ([\#69](https://github.com/Gilead-BioStats/qcthat/issues/69),
  [\#73](https://github.com/Gilead-BioStats/qcthat/issues/73)).
- `Action_QCPRIssues()` to run
  [`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md)
  for specific pull requests
  ([\#55](https://github.com/Gilead-BioStats/qcthat/issues/55),
  [\#68](https://github.com/Gilead-BioStats/qcthat/issues/68)).
- `Action_QCMilestone()` to run
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMilestones.md)
  for pull requests associated with milestones, and for releases with
  names that match milestones
  ([\#68](https://github.com/Gilead-BioStats/qcthat/issues/68),
  [\#88](https://github.com/Gilead-BioStats/qcthat/issues/88)).

### Other changes

This release also includes a number of helper functions and internal
improvements.

## qcthat 0.2.0

This is a complete rewrite of the package to implement a framework that
links GitHub issues to evidence that those issues have been implemented.

### New features

- Function
  [`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/FetchRepoIssues.md)
  to get issues from a GitHub repository and compile them into a
  user-friendly data frame
  ([\#34](https://github.com/Gilead-BioStats/qcthat/issues/34),
  [\#47](https://github.com/Gilead-BioStats/qcthat/issues/47)).
- Function
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileTestResults.md)
  to extract test results from `testthat` test runs and compile them
  into a user-friendly data frame
  ([\#32](https://github.com/Gilead-BioStats/qcthat/issues/32)).
- Function
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  to link GitHub issues to test results, producing an `IssueTestMatrix`
  object that summarizes the state of issues and their associated tests
  ([\#35](https://github.com/Gilead-BioStats/qcthat/issues/35),
  [\#49](https://github.com/Gilead-BioStats/qcthat/issues/49)).
- Custom print methods for `qcthat_SingleIssueTestResults`,
  `qcthat_Milestone`, and `qcthat_IssueTestMatrix` objects to display
  their contents in a user-friendly tree format
  ([\#31](https://github.com/Gilead-BioStats/qcthat/issues/31),
  [\#36](https://github.com/Gilead-BioStats/qcthat/issues/36),
  [\#45](https://github.com/Gilead-BioStats/qcthat/issues/45),
  [\#60](https://github.com/Gilead-BioStats/qcthat/issues/60),
  [\#61](https://github.com/Gilead-BioStats/qcthat/issues/61)).
