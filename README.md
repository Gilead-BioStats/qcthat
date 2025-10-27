
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {qcthat} ✅

<!-- badges: start -->

[![R-CMD-check](https://github.com/Gilead-BioStats/qcthat/workflows/R-CMD-check-main/badge.svg)](https://github.com/Gilead-BioStats/qcthat/actions)
[![Codecov test
coverage](https://codecov.io/gh/Gilead-BioStats/qcthat/graph/badge.svg)](https://app.codecov.io/gh/Gilead-BioStats/qcthat)

<!-- badges: end -->

`{qcthat}` is a quality control framework for R packages, particularly
those used in Clinical Trials. It is being adapted from the
qualification framework used in the `gsm` family of packages, such as
[`{gsm.core}`](https://github.com/Gilead-BioStats/gsm.core) and
[`{gsm.app}`](https://github.com/Gilead-BioStats/gsm.app).

The goal of `{qcthat}` is to provide a qualification report linking
GitHub issues to evidence that those issues have been implemented. This
report can be used as part of a quality control and acceptance process
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
    Bryan](https://r-pkgs.org/software-development-practices.html)).
2.  Use {testthat} to verify the implementation of those requirements
    (see the [Testing section of *R Packages (2e)* by Hadley Wickham and
    Jennifer Bryan](https://r-pkgs.org/testing-basics.html)).
3.  Link tests to issues by including `#{issue_number}` in the test
    description, such as:

``` r
test_that("Users can view a matrix of GitHub issues and test results (#31)", {
  # Expectations that prove that this worked.
})
```

## 📋 Example Report Process

A sample [GitHub Action to generate a report is included in this
repository](https://github.com/Gilead-BioStats/qcthat/blob/dev/.github/workflows/qcthis.yaml)
(coming soon to the package itself). This is the process that it
follows:

### Capture {testthat} test results

Run the local testthat tests with `stop_on_failure = FALSE`, and assign
the result to a variable. We use the “silent” reporter to avoid
unnecessary output.

``` r
lTestResults <- testthat::test_local(
  stop_on_failure = FALSE,
  reporter = "silent"
)
```

The resulting object is a list with class `"testthat_results"`. {qcthat}
parses that object to link test results to issues.

### Generate Issue-Test Matrix

Use `qcthat::FetchRepoIssues()` to get the issues for the repository
connected to the active project, and compile the test results with
`qcthat::CompileTestResults()`. Together these data frames are used by
`qcthat::CompileIssueTestMatrix()` to create a nested tibble with class
`"qcthat_IssueTestMatrix"` which links issues to tests. Printing the
`"qcthat_IssueTestMatrix"` object produces a human-readable summary of
the results.

``` r
IssueTestMatrix <- qcthat::CompileIssueTestMatrix(
  dfRepoIssues = qcthat::FetchRepoIssues(),
  dfTestResults = qcthat::CompileTestResults(lTestResults)
)
print(IssueTestMatrix)
```

For example, this is the output for a recent report for this {qcthat}
repository.

    # A qcthat issue test matrix with 2 milestones, 24 issues, and 16 tests
    █
    ├─█─Milestone: <none> (17 issues)
    │ ├─█─📥─Technical Task 49: Unnest IssueTestMatrix for easier filtering
    │ │    └─(no tests)
    │ ├─█─📥─Feature 48: Add filters (and apply by default)
    │ │    └─(no tests)
    │ ├─█─📥─Bug 47: Fetch *all* repo issues
    │ │    └─(no tests)
    │ ├─█─📥─Feature 46: Wrapper to run everything
    │ │    └─(no tests)
    │ ├─█─📥─Bug 45: Deal with length-0 results
    │ │    └─(no tests)
    │ ├─█─📥─Feature 44: Helper to run tests
    │ │    └─(no tests)
    │ ├─█─📥─Documentation Task 43: Log Process in README
    │ │    └─(no tests)
    │ ├─█─📥─Feature 42: Print as HTML
    │ │    └─(no tests)
    │ ├─█─📥─Feature 41: Function to Implement GHA
    │ │    └─(no tests)
    │ ├─█─📥─Feature 40: Print Without Milestones
    │ │    └─(no tests)
    │ ├─█─📥─Feature 39: Add print methods for sub-parts
    │ │    └─(no tests)
    │ ├─█─📥─Feature 38: Nest issues under parent
    │ │    └─(no tests)
    │ ├─█─📥─Technical Task 30: Update basic infrastructure
    │ │    └─(no tests)
    │ ├─█─☑️─Documentation Task 24: Outline business process for business requirements and testing
    │ │    └─(no tests)
    │ ├─█─⛔─Bug 21: Bugfix: Unit test coverage is missing
    │ │    └─(no tests)
    │ ├─█─⛔─Bug 19: Pull Requests don't currently get pulled in
    │ │    └─(no tests)
    │ └─█─<no issue>
    │      ├─✅─ExtractDisposition() helper counts warnings as errors
    │      ├─✅─ExtractDisposition() helper errors informatively for weird results
    │      ├─✅─Formatting an IssueTestMatrix can return the formatted tree directly
    │      ├─✅─AsExpectedDF works with empty dfs
    │      └─✅─AsExpectedDF works with non-empty dfs
    └─█─Milestone: v0.2.0 (8 issues)
      ├─█─☑️─Feature 37: Package QC Report GHA
      │    └─(no tests)
      ├─█─☑️─Feature 36: Print IssueTestMatrix
      │    ├─✅─Printing an IssueTestMatrix returns input invisibly (#36)
      │    └─✅─Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36)
      ├─█─☑️─Feature 35: Generate Issue-Test Matrix
      │    ├─✅─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35)
      │    ├─✅─CompileIssueTestMatrix combines issues and test results into an IssueTestMatrix tibble (#35)
      │    ├─✅─CompileIssueTestMatrix nests by milestone (#35)
      │    └─✅─CompileIssueTestMatrix nests by issue (#35)
      ├─█─☑️─Feature 34: Get repo issues
      │    ├─✅─FetchRepoIssues returns an empty df when no issues found (#34)
      │    └─✅─FetchRepoIssues returns a formatted df for real issues (#34)
      ├─█─☑️─Feature 32: Extract test information from test results
      │    ├─✅─CompileTestResults errors informatively for bad input (#32)
      │    ├─✅─CompileTestResults works for empty testthat_results (#32)
      │    └─✅─CompileTestResults returns the expected object (#32)
      ├─█─☑️─Requirement 31: Generate package QC report
      │    └─✅─Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36)
      ├─█─☑️─Technical Task 20: Fix pkgdown github workflows
      │    └─(no tests)
      └─█─📥─Requirement 18: Capture requirements via issues
           └─(no tests)
    # Issue state: 📥 = open, ☑️ = closed (completed), ⛔ = closed (won't fix)
    # Test disposition: ✅ = passed, ❌ = failed, 🚫 = skipped

## 📄 Example Business Process

Here we describe a business process for implementing quality control
using `{qcthat}`. This process is intended to ensure that program
development, testing, review, and acceptance are conducted in a
structured manner. Additional (optional) configuration details for each
core step are described in the following sections.

### Roles

- 👑 or TL: Team Lead
- 💻 or PD: Program Developer
- 🧪 or QCP: Quality Control Programmer
- 💼 or USR: User or Requester
- 🤖 or AUTO: Automated System

### Overview

1.  **💻 File Issues:** Program developer documents feature/programming
    requirements using Github Issues.
2.  **💻 Write Code:** Program developer updates code and associated
    documentation in R package.
3.  **🧪 Write Tests:** Quality Control Programmer writes needed tests
    and includes a link to the issue by including `(#{issue_number})` in
    the test description.
4.  **🤖 Release Package:** Upon a GitHub release, all tests are
    automatically ran and a summary report linking issues with
    associated tests is created and attached to the release.

### Intake 💻💼

- 💻💼: PD receives feature/programming request from USR.
- 💻💼: PD documents feature/programming request from USR using Github
  Issues.
- 💻: PD creates an issue for each Business Requirement.
- 💻: PD creates and links separate issues or sub-issues to document
  technical requirements and implementation details for each business
  requirement.

### Code Development 💻👑🧪💼

- 💻: PD develops or modifies program using the user requirements.
- 👑💻🧪💼: All stakeholders (PD, TL, QCP and USR) add comments and
  reactions on the issue to finalize scope as needed.
- 👑💼: USR and/or TL documents approval of business requirements via
  comment or a “thumbs up” reaction as needed.
- 💻: PD provides clear description of changes with every commit
  comment. If developer chooses to provide a message addressing a
  specific change, the commit comment should be a descriptive, concise,
  single-line summary of the change. If more context is needed, PD
  should add a comment to an issue in GitHub.

### Testing 💻🧪

- 💻🧪🤖: Where applicable, QCP or PD defines an automated test for
  every applicable user requirement to demonstrate that the information
  displayed by the report/application is fit for purpose and meets the
  stated requirement. Testing is performed by using common frameworks
  {testthat} and {shinytest2} depending on the development process.
  Tests are linked to the corresponding business requirements with
  “(#{issue_number})” in the description.
- 💻🧪🤖: Testing strategy for each requirement is documented by
  updating the Business Requirement GitHub issues or by referencing the
  issue number in the commit message for test code. Testing is executed
  via automated services (such as GitHub Actions).

### Code Review 💻🧪

- 💻: Upon completion of code development and testing, the PD initiates
  a Pull Request (PR). All relevant issues and tests are linked to the
  PR.
- 🧪: QCP determines appropriate level of review. Verifies the code
  and/or output against the user requirements and documents the method
  and results.
- 💻🧪: All questions and necessary code adjustments are addressed in
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

### Release 💻🧪

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

Please note that the {qcthat} project is released with a [Contributor
Code of
Conduct](https://gilead-biostats.github.io/qcthat/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
