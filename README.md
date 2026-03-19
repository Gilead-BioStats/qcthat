
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {qcthat} <a href="https://gilead-biostats.github.io/qcthat/"><img src="man/figures/logo.svg" align="right" height="318" alt="qcthat website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/Gilead-BioStats/qcthat/workflows/R-CMD-check/badge.svg)](https://github.com/Gilead-BioStats/qcthat/actions)
[![Codecov test
coverage](https://codecov.io/gh/Gilead-BioStats/qcthat/graph/badge.svg)](https://app.codecov.io/gh/Gilead-BioStats/qcthat)

<!-- badges: end -->

`{qcthat}` is a quality control framework for R packages. It has been
developed for use in the `gsm` family of packages, such as
[`{gsm.core}`](https://github.com/Gilead-BioStats/gsm.core).

The goal of `{qcthat}` is to produce qualification reports linking
GitHub issues to evidence that those issues have been implemented. These
reports can be used as part of a quality control and acceptance process
for R packages, particularly those used in regulated environments such
as clinical trials.

## ⚙️ Installation and Setup

You can install the development version of `{qcthat}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Gilead-BioStats/qcthat")
```

To utilize `{qcthat}`, you must

1.  Use GitHub Issues to document requirements (see [Chapter 20:
    Software development practices from *R Packages (2e)* by Hadley
    Wickham and Jennifer
    Bryan](https://r-pkgs.org/software-development-practices.html) and
    `usethis::use_github()`).
2.  Use `{testthat}` to verify the implementation of those requirements
    (see the [Testing section of *R Packages (2e)* by Hadley Wickham and
    Jennifer Bryan](https://r-pkgs.org/testing-basics.html) and
    `usethis::use_testthat()`).
3.  Link tests to issues by including `(#{issue_number})` in the test
    description, such as:

``` r
test_that("Users can view a matrix of GitHub issues and test results (#31)", {
  # Expectations that prove that this worked.
})
```

## 📋 Example Report Process

`Action_qcthat()` installs a GitHub action to generate QC reports. At
its core, it uses the functions `QCPackage()`, `QCPR()`,
`QCCompletedIssues()`, and `QCMilestones()` to generate a report like
this:

<details>

<summary>

✅ A qcthat issue test matrix with 1 milestone, 19 issues, and 59 tests
</summary>

    └─█─Milestone: v1.0.0 (19 issues, 59 tests)
      ├─☑️─Technical Task 101: Switch `lglShowIgnoredLabels` default to TRUE
      │ └─✅─Ignored issues are shown by default (#101)
      ├─☑️─Feature 80: Filter main qcthat report to only "closed (completed)"
      │ └─✅─QCCompletedIssues filters to completed issues (#80, #69)
      ├─☑️─Bug 77: GHA-generated report stability
      │ └─✅─Reports generated via GHA include information about the issues (#77, #37)
      ├─☑️─Feature 73: Add qcthis.yaml to a package
      │ ├─✅─InstallAction calls InstallFile with expected parts (#73)
      │ ├─✅─Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)
      │ ├─✅─qcthatPath constructs paths (#73)
      │ └─✅─InstallFile copies files as expected (#73)
      ├─☑️─Technical Task 72: Add qc report to triggering PR as comment
      │ └─✅─CommentReport generates the expected call (#99, #72)
      ├─☑️─Requirement 69: Package QC Report Usability
      │ ├─✅─Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)
      │ ├─✅─Can print without milestone info (#40, #69)
      │ ├─✅─QCPackage wraps the core qcthat functions (#46, #69)
      │ └─✅─QCCompletedIssues filters to completed issues (#80, #69)
      ├─☑️─Requirement 68: PR/Branch Report
      │ ├─✅─Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)
      │ ├─✅─QCMergeGH filters to merge-associated issues (#68, #84)
      │ ├─✅─QCMergeLocal filters to ref-specific issues (#68, #84)
      │ ├─✅─QCPR filters to PR-related issues (#68, #84)
      │ └─✅─QCMilestones reports on specific milestones (#88, #68)
      ├─☑️─Feature 67: Ignore issues with `qcthat-nocov` label
      │ ├─✅─CompileIssueTestMatrix excludes issues in chrIgnoredLabels (#67)
      │ ├─✅─ExtractDisposition() helper counts test errors as failures (#67)
      │ └─✅─Can report ignored issue counts (#67, #81)
      ├─☑️─Feature 55: GHA: Report of associated issues
      │ └─✅─Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)
      ├─☑️─Feature 46: Wrapper to run everything
      │ └─✅─QCPackage wraps the core qcthat functions (#46, #69)
      ├─☑️─Feature 40: Print Without Milestones
      │ └─✅─Can print without milestone info (#40, #69)
      ├─☑️─Bug 96: Don't include ignored labels in `QCIssues()` warnings
      │ └─✅─QCIssues doesn't warn about ignored issues (#96)
      ├─☑️─Bug 95: Install qcthat as part of Action installation
      │ └─✅─qcthat is installed as part of the GHA (#95)
      ├─☑️─Feature 90: Function to create qcthat-nocov label
      │ ├─✅─CreateGHLabel reports success conditional on lglVerbose (#90)
      │ ├─✅─CreateGHLabel throws an error if the API doesn't report the expected result (#90)
      │ ├─✅─CreateGHLabel attempts to update existing label (#90)
      │ ├─✅─MaybeUpdateGHLabel decides based on lglUpdate (#90)
      │ ├─✅─UpdateGHLabel makes the expected call (#90)
      │ ├─✅─UpdateGHLabel throws an error if the API doesn't report the expected result (#90)
      │ ├─✅─EmptyLabelsDF returns the expected structure (#90)
      │ ├─✅─EnframeGHLabels returns NULL for empty list (#90)
      │ ├─✅─EnframeGHLabels converts raw labels to data frame (#90)
      │ ├─✅─EnframeGHLabels adds hash to color codes (#90)
      │ ├─✅─FetchGHLabelsRaw calls the correct API endpoint (#90)
      │ ├─✅─FetchGHLabels returns empty data frame when no labels exist (#90)
      │ ├─✅─FetchGHLabels returns data frame with labels (#90)
      │ ├─✅─Default helpers return expected values (#90)
      │ ├─✅─SetupGHLabels creates missing labels (#90)
      │ ├─✅─PrepareDFLabels normalizes correctly (#90)
      │ ├─✅─Helper functions normalize strings correctly (#90)
      │ └─✅─ValidateDFLabels checks for required columns (#90)
      ├─☑️─Feature 88: Report by Milestone
      │ ├─✅─Action_qcthat targets the expected action (#55, #68, #69, #73, #88, #141, #157, #198)
      │ ├─✅─QCMilestones reports on specific milestones (#88, #68)
      │ ├─✅─QCMilestones warns about unknown milestones (#88)
      │ └─✅─QCMilestones errors with no valid milestones (#88)
      ├─☑️─Feature 86: Function to report on specific issues
      │ ├─✅─QCIssues reports on specific issues (#86)
      │ ├─✅─QCIssues warns about unknown issues (#86)
      │ └─✅─QCIssues errors with no valid issues (#86)
      ├─☑️─Feature 85: Report Issue-Test Coverage in Footer
      │ ├─✅─Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36, #60, #85)
      │ └─✅─MakeITRCoverageFooter deals with all cases (#85)
      ├─☑️─Feature 84: Function(s) to filter report to issues associated with PR/branch
      │ ├─✅─FetchMergeCommitSHAs returns unique, sorted SHAs (#84, #133)
      │ ├─✅─FetchAllMergePRNumbers returns unique, sorted PR numbers (#84)
      │ ├─✅─FetchAllMergePRNumbers returns empty vector for no matching PRs (#84)
      │ ├─✅─FetchPRRefs returns source and target refs (#84, #133, #149)
      │ ├─✅─FetchRepoPRs returns an empty df when no issues found (#84)
      │ ├─✅─FetchRepoPRs returns a formatted df for real PRs (#84)
      │ ├─✅─GuessPRNumber delegates to its sub-functions (#84)
      │ ├─✅─GetGHAPRNumber returns NULL for bad arg (#84, #163)
      │ ├─✅─GetGHAPRNumber extracts PR number from lGHEventPayload when available (#84, #163)
      │ ├─✅─GetGHAPRNumber returns NULL for bad extracted PR number (#84, #163)
      │ ├─✅─FetchRefPRNumber fetches PR number for a branch (#84, #132)
      │ ├─✅─QCMergeGH filters to merge-associated issues (#68, #84)
      │ ├─✅─QCMergeLocal filters to ref-specific issues (#68, #84)
      │ ├─✅─FindKeywordIssues extracts issues that will be closed by commits (#84)
      │ ├─✅─QCPR errors informatively for bad intPRNumber (#84)
      │ ├─✅─QCPR filters to PR-related issues (#68, #84)
      │ ├─✅─PrepareGQLQuery constructs a query (#84)
      │ └─✅─GQLWrapper wraps a query correctly (#84)
      └─☑️─Requirement 81: Report issue test coverage
        └─✅─Can report ignored issue counts (#67, #81)
    # Issue state: 📥 = open, ☑️ = closed (completed), ⛔ = closed (won't fix)
    # Test disposition: ✅ = passed, ❌ = failed, 🚫 = skipped

</details>

✅ All tests passed

🟢 All issues have at least one test

🙈 2 issues with label “qcthat-nocov” were ignored

## 📄 Example Business Process

Here we describe a business process for implementing quality control
using `{qcthat}`. This process is intended to ensure that program
development, testing, review, and acceptance are conducted in a
structured manner. Additional (optional) configuration details for each
core step are described in the following sections.

### Roles

- 👑 or TL: Team Lead
- 🧑‍💻 or PD: Program Developer
- 🧪 or QCP: Quality Control Programmer
- 💼 or USR: User or Requester
- 🤖 or AUTO: Automated System

### Overview

1.  **🧑‍💻 File Issues:** Program developer documents feature/programming
    requirements using Github Issues.
2.  **🧑‍💻 Write Code:** Program developer updates code and associated
    documentation in R package.
3.  **🧪 Write Tests:** Quality Control Programmer writes needed tests
    and includes a link to the issue by including `(#{issue_number})` in
    the test description.
4.  **🤖 Release Package:** Upon a GitHub release, all tests are
    automatically run and a summary report linking issues with
    associated tests is created and attached to the release.

### Intake 🧑‍💻💼

- 🧑‍💻💼: PD receives feature/programming request from USR.
- 🧑‍💻💼: PD documents feature/programming request from USR using Github
  Issues.
- 🧑‍💻: PD creates an issue for each Business Requirement.
- 🧑‍💻: PD creates and links separate issues or sub-issues to document
  technical requirements and implementation details for each business
  requirement.

### Code Development 🧑‍💻👑🧪💼

- 🧑‍💻: PD develops or modifies program using the user requirements.
- 👑🧑‍💻🧪💼: All stakeholders (PD, TL, QCP and USR) add comments and
  reactions on the issue to finalize scope as needed.
- 👑💼: USR and/or TL documents approval of business requirements via
  comment or a “thumbs up” reaction as needed.
- 🧑‍💻: PD provides clear description of changes with every commit
  comment. If developer chooses to provide a message addressing a
  specific change, the commit comment should be a descriptive, concise,
  single-line summary of the change. If more context is needed, PD
  should add a comment to an issue in GitHub.

### Testing 🧑‍💻🧪

- 🧑‍💻🧪🤖: Where applicable, QCP or PD defines an automated test for
  every applicable user requirement to demonstrate that the information
  displayed by the report/application is fit for purpose and meets the
  stated requirement. Testing is performed by using common frameworks
  `{testthat}` and `{shinytest2}` depending on the development process.
  Tests are linked to the corresponding business requirements with
  “(#{issue_number})” in the description.
- 🧑‍💻🧪🤖: Testing strategy for each requirement is documented by
  updating the Business Requirement GitHub issues or by referencing the
  issue number in the commit message for test code. Testing is executed
  via automated services (such as GitHub Actions).

### Code Review 🧑‍💻🧪

- 🧑‍💻: Upon completion of code development and testing, the PD initiates
  a Pull Request (PR). All relevant issues and tests are linked to the
  PR.
- 🧪: QCP determines appropriate level of review. Verifies the code
  and/or output against the user requirements and documents the method
  and results.
- 🧑‍💻🧪: All questions and necessary code adjustments are addressed in
  the process of code review.

### QC and Acceptance 👑🧪

- 👑: Once the PD has addressed all required feedback, the TL conducts a
  final review of the code changes and documentation. TL verifies that
  all tests have passed, the website is successfully deployed (if
  applicable), and the release pull request (PR) correctly targets the
  primary branch.
- 👑🧪: When the qualification of the program is completed, QCP confirms
  and documents the result and acceptance. Final acceptance of the
  utility program or interactive report is documented by the TL or QCP
  through formal approval of the Pull Request (PR) within the SCM
  system. Once the request is approved, the finalized code is merged
  into the main code base and ready for release.

### Release 🧑‍💻🧪

- Upon acceptance, the PD or QCP creates a formal release in accordance
  with established version control conventions. This serves as
  documentation and as an equivalent of program deployment into a
  production environment.

## 🙋 Contributing

Contributions are welcome! Creating a utility package that is
generalizable and extensible to all sorts of repository structures is
challenging, and your input is greatly appreciated.

Before submitting a pull request, make sure to file an
[issue](https://github.com/Gilead-BioStats/qcthat/issues), which should
generally fall under one of the following categories:

- Bugfix: something is broken.
- Feature: something is wanted or needed.
- QC: documentation or metadata is incorrect or missing.

New code should generally follow the [tidyverse style
guide](https://style.tidyverse.org/).

### Code of Conduct

Please note that the `{qcthat}` project is released with a [Contributor
Code of
Conduct](https://gilead-biostats.github.io/qcthat/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
