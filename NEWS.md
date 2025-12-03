# qcthat 1.0.0

You can now use this package to implement a QC framework in any GitHub repository.

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
