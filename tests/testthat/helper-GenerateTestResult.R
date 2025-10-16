GenerateTestResult <- function(
  chrTestName,
  chrTestFile,
  chrDisposition = c("pass", "fail", "skip"),
  intGHIssues = integer()
) {
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
