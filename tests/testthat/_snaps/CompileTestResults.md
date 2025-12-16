# CompileTestResults errors informatively for bad input (#32)

    Code
      CompileTestResults(123)
    Condition
      Error in `CompileTestResults()`:
      ! Input must be a <testthat_results> object.
      i `lTestResults` is a number.

# ExtractDisposition() helper errors informatively for weird results (#32)

    Code
      ExtractDisposition(lTestResult)
    Condition
      Error in `ExtractDisposition()`:
      ! Unexpected result classes: "some_weird_class"

# ExtractDisposition() helper errors informatively for missing results within lTestResult object (#45)

    Code
      ExtractDisposition(lTestResult)
    Condition
      Error in `ExtractDisposition()`:
      ! No test results found.
      i You may need to rerun tests with a different `reporter`.
      i We recommend the "silent" reporter.

