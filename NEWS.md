# qcthat (development version)

This is a complete rewrite of the package to implement a framework that links GitHub issues to evidence that those issues have been implemented.

## New features

* Function `FetchRepoIssues()` to get issues from a GitHub repository and compile them into a user-friendly data frame (#34, #47).
* Function `CompileTestResults()` to extract test results from `testthat` test runs and compile them into a user-friendly data frame (#32).
* Function `CompileIssueTestMatrix()` to link GitHub issues to test results, producing an `IssueTestMatrix` object that summarizes the state of issues and their associated tests (#35, #49).
* Custom print methods for `qcthat_SingleIssueTestResults`, `qcthat_Milestone`, and `qcthat_IssueTestMatrix` objects to display their contents in a user-friendly tree format (#31, #36, #45, #60, #61).
