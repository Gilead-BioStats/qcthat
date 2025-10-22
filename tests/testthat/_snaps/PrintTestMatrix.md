# Printing an IssueTestMatrix returns input invisibly

    Code
      test_result <- withVisible(print(dfITM))
    Output
      # A qcthat issue test matrix with 0 milestones, 0 issues, and 0 tests

# Printing an IssueTestMatrix outputs a user-friendly tree

    Code
      dfITM
    Output
      # A qcthat issue test matrix with 2 milestones, 6 issues, and 8 tests
      █
      ├─█─Milestone: v0.2.0 (4 issues)
      │ ├─█─[o]─Feature 35: Generate Issue-Test Matrix
      │ │    ├─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      │ │    └─[!]─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)
      │ ├─█─[o]─Feature 34: Get repo issues
      │ │    ├─[v]─FetchRepoIssues returns an empty df when no issues found (#34)
      │ │    └─[v]─FetchRepoIssues returns a formatted df for real issues (#34)
      │ ├─█─[o]─Feature 32: Extract test information from test results
      │ │    ├─[v]─CompileTestResults errors informatively for bad input (#32)
      │ │    ├─[v]─CompileTestResults works for empty testthat_results (#32)
      │ │    └─[v]─CompileTestResults returns the expected object (#32)
      │ └─█─[o]─Requirement 31: Generate package QC report
      │      └─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)
      └─█─Milestone: <none> (3 issues)
        ├─█─[x]─Documentation Task 24: Outline business process for business requirements and testing
        │    └─(no tests)
        ├─█─[-]─Bug 21: Bugfix: Unit test coverage is missing
        │    └─(no tests)
        └─█─<no issue>
             └─[v]─ExtractDisposition() helper errors informatively for weird results
      # Issue state: [o] = open, [x] = closed (completed), [-] = closed (won't fix)
      # Test disposition: [v] = passed, [!] = failed, [S] = skipped

# Formatting an IssueTestMatrix can return the formatted tree directly

    Code
      format(dfITM)
    Output
       [1] "# A qcthat issue test matrix with 2 milestones, 6 issues, and 8 tests"                           
       [2] "█"                                                                                               
       [3] "├─█─Milestone: v0.2.0 (4 issues)"                                                                
       [4] "│ ├─█─[o]─Feature 35: Generate Issue-Test Matrix"                                                
       [5] "│ │    ├─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)"
       [6] "│ │    └─[!]─CompileIssueTestMatrix combines issues and test results into a nested tibble (#35)" 
       [7] "│ ├─█─[o]─Feature 34: Get repo issues"                                                           
       [8] "│ │    ├─[v]─FetchRepoIssues returns an empty df when no issues found (#34)"                     
       [9] "│ │    └─[v]─FetchRepoIssues returns a formatted df for real issues (#34)"                       
      [10] "│ ├─█─[o]─Feature 32: Extract test information from test results"                                
      [11] "│ │    ├─[v]─CompileTestResults errors informatively for bad input (#32)"                        
      [12] "│ │    ├─[v]─CompileTestResults works for empty testthat_results (#32)"                          
      [13] "│ │    └─[v]─CompileTestResults returns the expected object (#32)"                               
      [14] "│ └─█─[o]─Requirement 31: Generate package QC report"                                            
      [15] "│      └─[v]─CompileIssueTestMatrix returns an empty IssueTestMatrix with empty input (#35, #31)"
      [16] "└─█─Milestone: <none> (3 issues)"                                                                
      [17] "  ├─█─[x]─Documentation Task 24: Outline business process for business requirements and testing" 
      [18] "  │    └─(no tests)"                                                                             
      [19] "  ├─█─[-]─Bug 21: Bugfix: Unit test coverage is missing"                                         
      [20] "  │    └─(no tests)"                                                                             
      [21] "  └─█─<no issue>"                                                                                
      [22] "       └─[v]─ExtractDisposition() helper errors informatively for weird results"                 
      [23] "# Issue state: [o] = open, [x] = closed (completed), [-] = closed (won't fix)"                   
      [24] "# Test disposition: [v] = passed, [!] = failed, [S] = skipped"                                   

