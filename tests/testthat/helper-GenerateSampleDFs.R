GenerateSampleDFRepoIssues <- function() {
  # Selected issues from qcthat repo as of 2025-10-17.
  tibble::tibble(
    Issue = c(35L, 34L, 32L, 31L, 24L, 21L),
    Title = c(
      "Generate Issue-Test Matrix",
      "Get repo issues",
      "Extract test information from test results",
      "Generate package QC report",
      "Outline business process for business requirements and testing",
      "Bugfix: Unit test coverage is missing"
    ),
    Body = c(
      "## Summary\nJoin together the tables generated in #32 and #34.\n\n## Proposed Solution (Optional)\nThis might be a straight-up `dplyr::full_join()`. The result should probably be neatly nested to make it easy to iterate through it.\n\n## Example Usage (Optional)\nThis is the data that will be directly used to generate the report.\n\n## QC Approach\n<!-- How will the quality of the implementation be verified? -->\nIn addition to standard QC (e.g., code reviews, automated checks) the following QC measures will be implemented:\n\n- [x] Qualification Test via Double Programming\n- [x] Unit Tests\n- [ ] User Tests (e.g. visual comparison)",
      "## Summary\nCreate a table of information about repo issues.\n\n## Proposed Solution (Optional)\nThis should be relatively straightforward with the {gh} package. I've already done an over-complicated version of this.\n\n## Example Usage (Optional)\nWill be used in the test matrix report(s).\n\n## QC Approach\n<!-- How will the quality of the implementation be verified? -->\nIn addition to standard QC (e.g., code reviews, automated checks) the following QC measures will be implemented:\n\n- [x] Qualification Test via Double Programming\n- [x] Unit Tests\n- [ ] User Tests (e.g. visual comparison)",
      "## Summary\nGet information about a test run (test descriptions, disposition, etc).\n\n## Proposed Solution (Optional)\nFun fact: When you run testthat tests, they generate a \"testthat_results\" object, which is a list of lists. Each list contains information about a single `test_that()` (or, using the behavior-driven-development form of testthat, a `describe()` plus an `it()`). Extract information from that object for each test:\n- Full description.\n- Issue references via \"Tests #XXX\" in the description (each test can link to multiple issues).\n- Disposition (technically a count of dispositions; each `expect_that()` has a result here).\n- File (see if I can figure out how to find the specific location within the file for an even nicer experience in RStudio)\n- (consider other pieces of information that are available in the object, such as the body of the expectation)\n\n## Example Usage (Optional)\nWill be used in the test matrix report(s). Online, it'd be great if we can link to the line of the test file on GitHub.\n\n## QC Approach\n<!-- How will the quality of the implementation be verified? -->\nIn addition to standard QC (e.g., code reviews, automated checks) the following QC measures will be implemented:\n\n- [x] Qualification Test via Double Programming\n- [x] Unit Tests\n- [ ] User Tests (e.g. visual comparison)",
      "<!-- Link/assign related Feature, Bug, Technical, and Documentation sub-issues to this Requirement. -->\n\n## Summary\nUsers can easily see evidence of GitHub issue completion. This evidence will be in the form of a human readable matrix of GitHub issues and testthat results, filtered to tests that specifically mention issues.\n\n## Implementation Overview\nCreate R functions and GitHub Actions to generate a baseline version of a qualification report. For each issue in the repo, show info about the issue, and then a nested list of tests that reference that issue, and their results. See [this discussion comment](https://github.com/Gilead-BioStats/qcthat/discussions/27#discussioncomment-14690886) for a brainstorm about how this will work.\n\n## Affected Packages\n{qcthat} only (right now).\n\n## QC Approach\n<!-- Describe how the quality of the implementation will be verified. -->\n\nIn addition to the QC measures described in linked \"Features\" and \"Technical Tasks\" issues, the following QC measures will be implemented:\n\n- [x] Qualification Test via Double Programming\n- [x] Unit Tests\n- [x] User Tests (e.g. visual comparison)\n",
      "## Summary\nOutline business process for business requirements and testing according to updated SOP and BED\n",
      "## Expected Behavior\n<!--- What should happen -->\nUnit test coverage should be displayed in the Qualification report\n\n## Current Behavior\n<!--- What happens instead of the expected behavior -->\nUnit test coverage section is no longer included in the Qualification report\n\n## Possible Solution\n<!--- Not required, suggest a fix/reason for the bug, -->\n\n## Steps to Reproduce\n<!--- Provide a link to an example, or an unambiguous set of steps to -->\n<!--- reproduce this bug. Include code to reproduce, if relevant -->\n1.\n2.\n3.\n4.\n\n## Context (Environment)\n<!--- Providing context helps us reproduce the issue and come up with a solution -->\n\n## Possible Implementation\n<!--- Not required, suggest an idea for implementing addition or change -->\n\n## Additional Comments\n<!--- Not required, anything else import pertaining to this bug -->\n"
    ),
    Labels = list(NULL, NULL, NULL, NULL, "qcthat-nocov", NULL),
    State = c("open", "open", "open", "open", "closed", "closed"),
    StateReason = c(NA, NA, NA, NA, "completed", "not_planned"),
    Milestone = c("v0.2.0", "v0.2.0", "v0.2.0", "v0.2.0", NA, NA),
    Type = c(
      "Feature",
      "Feature",
      "Feature",
      "Requirement",
      "Documentation Task",
      "Bug"
    ),
    Url = c(
      "https://github.com/Gilead-BioStats/qcthat/issues/35",
      "https://github.com/Gilead-BioStats/qcthat/issues/34",
      "https://github.com/Gilead-BioStats/qcthat/issues/32",
      "https://github.com/Gilead-BioStats/qcthat/issues/31",
      "https://github.com/Gilead-BioStats/qcthat/issues/24",
      "https://github.com/Gilead-BioStats/qcthat/issues/21"
    ),
    ParentOwner = c(
      "Gilead-BioStats",
      "Gilead-BioStats",
      "Gilead-BioStats",
      NA,
      NA,
      NA
    ),
    ParentRepo = c("qcthat", "qcthat", "qcthat", NA, NA, NA),
    ParentNumber = c(31L, 31L, 31L, NA, NA, NA),
    CreatedAt = as.POSIXct(
      c(
        "2025-10-16",
        "2025-10-16",
        "2025-10-16",
        "2025-10-15",
        "2025-10-14",
        "2025-05-23"
      ),
      tz = "UTC"
    ),
    ClosedAt = as.POSIXct(
      c(NA, NA, NA, NA, "2025-10-15", "2025-10-15"),
      tz = "UTC"
    )
  ) |>
    AsIssuesDF()
}

GenerateSampleDFTestResults <- function() {
  # Test results as of 2025-10-17 just before I implemented this.
  tibble::tibble(
    Test = c(
      "CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)",
      "CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)",
      "CompileTestResults errors informatively for bad input (#32)",
      "CompileTestResults works for empty testthat_results (#32)",
      "CompileTestResults returns the expected object (#32)",
      "ExtractDisposition() helper errors informatively for weird results",
      "FetchRepoIssues returns an empty df when no issues found (#34)",
      "FetchRepoIssues returns a formatted df for real issues (#34)"
    ),
    File = c(
      "test-CompileIssueTestMatrix.R",
      "test-CompileIssueTestMatrix.R",
      "test-CompileTestResults.R",
      "test-CompileTestResults.R",
      "test-CompileTestResults.R",
      "test-CompileTestResults.R",
      "test-FetchRepoIssues.R",
      "test-FetchRepoIssues.R"
    ),
    Disposition = factor(
      c("pass", "fail", "pass", "pass", "pass", "pass", "pass", "pass"),
      levels = c("fail", "skip", "pass")
    ),
    Issues = list(c(35L, 31L), 35L, 32L, 32L, 32L, integer(), 34L, 34L)
  ) |>
    AsTestResultsDF()
}
