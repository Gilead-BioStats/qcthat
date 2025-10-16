GenerateTestResult <- function(
  chrTestName,
  chrTestFile,
  chrDisposition = c("pass", "fail", "skip"),
  intGHIssues = integer()
) {
  chrDisposition <- match.arg(chrDisposition)
  classes <- switch(
    chrDisposition,
    pass = c("expectation_success", "expectation", "condition"),
    fail = c("expectation_failure", "expectation", "error", "condition"),
    skip = c("expectation_skip", "expectation", "condition")
  )

  list(
    file = chrTestFile,
    test = chrTestName,
    results = list(
      structure(
        list(),
        class = classes
      )
    ),
    issues = as.integer(intGHIssues)
  )
}

GenerateStandardTestResults <- function() {
  structure(
    list(
      GenerateTestResult(
        "First test with one GH issue (#32)",
        "test-file1.R",
        "pass",
        32
      ),
      GenerateTestResult(
        "Second test with multiple GH issues (#32, #33, #34)",
        "test-file1.R",
        "pass",
        32:34
      ),
      GenerateTestResult(
        "Third test with 0 GH issues, failure",
        "test-file2.R",
        "fail",
        integer()
      ),
      GenerateTestResult(
        "Fourth test with 1 GH issue, skipped (#35)",
        "test-file2.R",
        "skip",
        35
      )
    ),
    class = "testthat_results"
  )
}
