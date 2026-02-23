# qcthat 1.1.0

New features and tools to help you track user acceptance testing, and to help you use AI agents to get started with `qcthat`.

## New features

Experimental functions for tracking user-acceptance testing (UAT):

* `ExpectUserAccepts()` enables tracking of user acceptance by connecting `testthat` tests to GitHub issues. Once the UAT issue is closed, the test will pass (#65, #111, #113, #115, #120).
* `TriggerUAT()` triggers the UAT test cycle for a closed issue. This function is used by the improved GitHub Actions framework, installable via `Action_qcthat()` (#65, #111, #114, #115, #116, #157).

Improved onboarding:

* `use_qcthat()` calls `SetupGHLabels()` and `Action_qcthat()`, to set up your repository with GitHub Actions workflows and labels used for QC tracking (#129, #141, #143, #161, #165, #181, #198).
* Experimental AI agent features: `Skill_TagTestsWithIssues()` installs an AI agent skill to tag tests with issues, using new functions `ExtractTestsFromFiles()`, `MapTestFilesToPotentialIssues()`, and `PrepareTestIssueContext()` (#52, #53, #200, #201, #233).

## Other changes

* Additional improvements to QC reports, such as links to the GitHub Actions run (#150), timestamps (#172), and attaching QC Reports to releases within the release description (#152). Additional changes are tracked in the parent issues (#123, #160).
* The `pkgdown` site for `qcthat` now includes a slide deck to introduce the package and the associated system (#166, #167, #168, #169).

## Bug fixes

* Ignored issues are filtered out of reports (#118).
* Reports work properly when the active branch is associated with multiple PRs (#132), when the PRs contain a lot of commits (#133), and after PRs are merged (#149).
* `GetGHOwner()` and `GetGHRepo()` should now work for forks, even if the local repo name does not match the upstream repo name (#199).

# qcthat 1.0.0

You can now use this package to implement a QC framework for any R package associated with a GitHub repository.

## New features

A series of `QC*()` functions to generate QC reports for different sets of issues:

* `QCPackage()` for all issues and tests for an R package and its associated GitHub repository (#46, #69).
* `QCCompletedIssues()` for only issues closed as completed (#69, #80).
* `QCIssues()` for specific issues (#86), and `QCMilestones()` for issues associated with specific named milestones (#68, #88)
* `QCPR()` for issues associated with specific GitHub pull requests, `QCMergeGH()` to generalize to issues associated with any GitHub merge using GitHub's graph to determine connections, and `QCMergeLocal()` to detect probable associations based on commit messages (#68, #84).

A series of `Action_*()` functions to set up GitHub actions for QC reports:

* `Action_QCCompletedIssues()` to run `QCCompletedIssues()` (#69, #73).
* `Action_QCPRIssues()` to run `QCPR()` for specific pull requests (#55, #68).
* `Action_QCMilestone()` to run `QCMilestones()` for pull requests associated with milestones, and for releases with names that match milestones (#68, #88).

## Other changes

This release also includes a number of helper functions and internal improvements.

# qcthat 0.2.0

This is a complete rewrite of the package to implement a framework that links GitHub issues to evidence that those issues have been implemented.

## New features

* Function `FetchRepoIssues()` to get issues from a GitHub repository and compile them into a user-friendly data frame (#34, #47).
* Function `CompileTestResults()` to extract test results from `testthat` test runs and compile them into a user-friendly data frame (#32).
* Function `CompileIssueTestMatrix()` to link GitHub issues to test results, producing an `IssueTestMatrix` object that summarizes the state of issues and their associated tests (#35, #49).
* Custom print methods for `qcthat_SingleIssueTestResults`, `qcthat_Milestone`, and `qcthat_IssueTestMatrix` objects to display their contents in a user-friendly tree format (#31, #36, #45, #60, #61).
