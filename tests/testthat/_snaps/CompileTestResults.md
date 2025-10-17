# CompileTestResults errors informatively for bad input (#32)

    Code
      CompileTestResults(123)
    Condition
      Error in `CompileTestResults()`:
      ! Input must be a <testthat_results> object.
      i `lTestResults` is a number.

# ExtractDisposition() helper errors informatively for weird results

    Code
      ExtractDisposition(lTestResult)
    Condition
      Error in `ExtractDisposition()`:
      ! Unexpected result classes: "some_weird_class"

