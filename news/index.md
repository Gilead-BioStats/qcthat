# Changelog

## qcthat 1.0.0

You can now use this package to implement a QC framework for any R
package associated with a GitHub repository.

### New features

A series of `QC*()` functions to generate QC reports for different sets
of issues:

- [`QCPackage()`](https://gilead-biostats.github.io/qcthat/reference/QCPackage.md)
  for all issues and tests for an R package and its associated GitHub
  repository
  ([\#46](https://github.com/Gilead-BioStats/qcthat/issues/46),
  [\#69](https://github.com/Gilead-BioStats/qcthat/issues/69)).
- [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/reference/QCCompletedIssues.md)
  for only issues closed as completed
  ([\#69](https://github.com/Gilead-BioStats/qcthat/issues/69),
  [\#80](https://github.com/Gilead-BioStats/qcthat/issues/80)).
- [`QCIssues()`](https://gilead-biostats.github.io/qcthat/reference/QCIssues.md)
  for specific issues
  ([\#86](https://github.com/Gilead-BioStats/qcthat/issues/86)), and
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/reference/QCMilestones.md)
  for issues associated with specific named milestones
  ([\#68](https://github.com/Gilead-BioStats/qcthat/issues/68),
  [\#88](https://github.com/Gilead-BioStats/qcthat/issues/88))
- [`QCPR()`](https://gilead-biostats.github.io/qcthat/reference/QCPR.md)
  for issues associated with specific GitHub pull requests,
  [`QCMergeGH()`](https://gilead-biostats.github.io/qcthat/reference/QCMergeGH.md)
  to generalize to issues associated with any GitHub merge using
  GitHub’s graph to determine connections, and
  [`QCMergeLocal()`](https://gilead-biostats.github.io/qcthat/reference/QCMergeLocal.md)
  to detect probable associations based on commit messages
  ([\#68](https://github.com/Gilead-BioStats/qcthat/issues/68),
  [\#84](https://github.com/Gilead-BioStats/qcthat/issues/84)).

A series of `Action_*()` functions to set up GitHub actions for QC
reports:

- [`Action_QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/reference/Action_QCCompletedIssues.md)
  to run
  [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/reference/QCCompletedIssues.md)
  ([\#69](https://github.com/Gilead-BioStats/qcthat/issues/69),
  [\#73](https://github.com/Gilead-BioStats/qcthat/issues/73)).
- [`Action_QCPRIssues()`](https://gilead-biostats.github.io/qcthat/reference/Action_QCPRIssues.md)
  to run
  [`QCPR()`](https://gilead-biostats.github.io/qcthat/reference/QCPR.md)
  for specific pull requests
  ([\#55](https://github.com/Gilead-BioStats/qcthat/issues/55),
  [\#68](https://github.com/Gilead-BioStats/qcthat/issues/68)).
- [`Action_QCMilestone()`](https://gilead-biostats.github.io/qcthat/reference/Action_QCMilestone.md)
  to run
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/reference/QCMilestones.md)
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
  [`FetchRepoIssues()`](https://gilead-biostats.github.io/qcthat/reference/FetchRepoIssues.md)
  to get issues from a GitHub repository and compile them into a
  user-friendly data frame
  ([\#34](https://github.com/Gilead-BioStats/qcthat/issues/34),
  [\#47](https://github.com/Gilead-BioStats/qcthat/issues/47)).
- Function
  [`CompileTestResults()`](https://gilead-biostats.github.io/qcthat/reference/CompileTestResults.md)
  to extract test results from `testthat` test runs and compile them
  into a user-friendly data frame
  ([\#32](https://github.com/Gilead-BioStats/qcthat/issues/32)).
- Function
  [`CompileIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/reference/CompileIssueTestMatrix.md)
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
