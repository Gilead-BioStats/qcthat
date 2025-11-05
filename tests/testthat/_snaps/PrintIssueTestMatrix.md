# Printing an IssueTestMatrix returns input invisibly (#31)

    Code
      test_result <- withVisible(print(dfITM))
    Output
      █ A qcthat issue test matrix with 0 milestones, 0 issues, and 0 tests

# Printing an IssueTestMatrix outputs a user-friendly tree (#31, #36, #60)

    Code
      dfITM
    Output
      [!] A qcthat issue test matrix with 1 milestone, 6 issues, and 8 tests
      ├─█─Milestone: v0.2.0 (4 issues, 7 tests)
      │ ├─[o]─Feature 35: Generate Issue-Test Matrix
      │ │ ├─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      │ │ └─[!]─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)
      │ ├─[o]─Feature 34: Get repo issues
      │ │ ├─[v]─FetchRepoIssues returns an empty df when no issues found (#34)
      │ │ └─[v]─FetchRepoIssues returns a formatted df for real issues (#34)
      │ ├─[o]─Feature 32: Extract test information from test results
      │ │ ├─[v]─CompileTestResults errors informatively for bad input (#32)
      │ │ ├─[v]─CompileTestResults works for empty testthat_results (#32)
      │ │ └─[v]─CompileTestResults returns the expected object (#32)
      │ └─[o]─Requirement 31: Generate package QC report
      │   └─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      └─█─Milestone: <none> (2 issues, 1 test)
        ├─[x]─Documentation Task 24: Outline business process for business requirements and testing
        │ └─(no tests)
        ├─[-]─Bug 21: Bugfix: Unit test coverage is missing
        │ └─(no tests)
        └─█─<no issue>
          └─[v]─ExtractDisposition() helper errors informatively for weird results
      # Issue state: [o] = open, [x] = closed (completed), [-] = closed (won't fix)
      # Test disposition: [v] = passed, [!] = failed, [S] = skipped
      
      [!] At least one test failed

