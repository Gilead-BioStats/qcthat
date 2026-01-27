# CommentReport generates the expected call (#99, #72)

    Code
      CommentReport(dfITM, strReportType = "Testing", intPRNumber = 99, strRunID = "",
        strOwner = "owner", strRepo = "repo", strGHToken = "token")
    Output
      [[1]]
      [1] 99
      
      $strTitle
      [1] "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: Testing"
      
      $strBody
      <details>
      <summary>❌ A qcthat issue test matrix with 1 milestone, 6 issues, and 8 tests</summary>
      
      ```
      ├─█─Milestone: v0.2.0 (4 issues, 7 tests)
      │ ├─📥─Feature 35: Generate Issue-Test Matrix
      │ │ ├─✅─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      │ │ └─❌─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)
      │ ├─📥─Feature 34: Get repo issues
      │ │ ├─✅─FetchRepoIssues returns an empty df when no issues found (#34)
      │ │ └─✅─FetchRepoIssues returns a formatted df for real issues (#34)
      │ ├─📥─Feature 32: Extract test information from test results
      │ │ ├─✅─CompileTestResults errors informatively for bad input (#32)
      │ │ ├─✅─CompileTestResults works for empty testthat_results (#32)
      │ │ └─✅─CompileTestResults returns the expected object (#32)
      │ └─📥─Requirement 31: Generate package QC report
      │   └─✅─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      └─█─Milestone: <none> (2 issues, 1 test)
        ├─☑️─Documentation Task 24: Outline business process for business requirements and testing
        │ └─(no tests)
        ├─⛔─Bug 21: Bugfix: Unit test coverage is missing
        │ └─(no tests)
        └─█─<no issue>
          └─✅─ExtractDisposition() helper errors informatively for weird results
      # Issue state: 📥 = open, ☑️ = closed (completed), ⛔ = closed (won't fix)
      # Test disposition: ✅ = passed, ❌ = failed, 🚫 = skipped
      ```
      </details>
      ❌ 1 test failed
      
      ⭕ 2 issues lack tests
      
      ⛓️‍💥 1 test is not linked to any issue
      
      $strRunID
      [1] ""
      
      $lglUpdate
      [1] TRUE
      
      $strOwner
      [1] "owner"
      
      $strRepo
      [1] "repo"
      
      $strGHToken
      [1] "token"
      

