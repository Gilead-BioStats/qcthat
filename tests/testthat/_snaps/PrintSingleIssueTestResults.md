# Printing a SingleIssueTestResults outputs a user-friendly tree (#39)

    Code
      lSeparatedIssueTestResults[[1]]
    Output
      [o]─Feature 35: Generate Issue-Test Matrix
      ├─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      └─[!]─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)

---

    Code
      lSeparatedIssueTestResults[[2]]
    Output
      [o]─Feature 34: Get repo issues
      ├─[v]─FetchRepoIssues returns an empty df when no issues found (#34)
      └─[v]─FetchRepoIssues returns a formatted df for real issues (#34)

---

    Code
      lSeparatedIssueTestResults[[3]]
    Output
      [o]─Feature 32: Extract test information from test results
      ├─[v]─CompileTestResults errors informatively for bad input (#32)
      ├─[v]─CompileTestResults works for empty testthat_results (#32)
      └─[v]─CompileTestResults returns the expected object (#32)

---

    Code
      lSeparatedIssueTestResults[[4]]
    Output
      [o]─Requirement 31: Generate package QC report
      └─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)

---

    Code
      lSeparatedIssueTestResults[[1]]
    Output
      [x]─Documentation Task 24: Outline business process for business requirements and testing
      └─(no tests)

---

    Code
      lSeparatedIssueTestResults[[2]]
    Output
      [-]─Bug 21: Bugfix: Unit test coverage is missing
      └─(no tests)

---

    Code
      lSeparatedIssueTestResults[[3]]
    Output
      █─<no issue>
      └─[v]─ExtractDisposition() helper errors informatively for weird results

