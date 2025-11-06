# Printing a Milestone outputs a user-friendly tree (#39)

    Code
      lMilestones[[1]]
    Output
      █─Milestone: v0.2.0 (4 issues, 7 tests)
      ├─[o]─Feature 35: Generate Issue-Test Matrix
      │ ├─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      │ └─[!]─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)
      ├─[o]─Feature 34: Get repo issues
      │ ├─[v]─FetchRepoIssues returns an empty df when no issues found (#34)
      │ └─[v]─FetchRepoIssues returns a formatted df for real issues (#34)
      ├─[o]─Feature 32: Extract test information from test results
      │ ├─[v]─CompileTestResults errors informatively for bad input (#32)
      │ ├─[v]─CompileTestResults works for empty testthat_results (#32)
      │ └─[v]─CompileTestResults returns the expected object (#32)
      └─[o]─Requirement 31: Generate package QC report
        └─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)

---

    Code
      lMilestones[[2]]
    Output
      █─Milestone: <none> (2 issues, 1 test)
      ├─[x]─Documentation Task 24: Outline business process for business requirements and testing
      │ └─(no tests)
      ├─[-]─Bug 21: Bugfix: Unit test coverage is missing
      │ └─(no tests)
      └─█─<no issue>
        └─[v]─ExtractDisposition() helper errors informatively for weird results

