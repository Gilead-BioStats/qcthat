# Changelog

## qcthat (development version)

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
