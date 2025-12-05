test_that("CompileConditionClasses compiles classes as expected", {
  expect_equal(
    CompileConditionClasses("this_subclass"),
    c("qcthat-error-this_subclass", "qcthat-error", "qcthat-condition")
  )
  expect_equal(
    CompileConditionClasses("this_subclass", "warning"),
    c("qcthat-warning-this_subclass", "qcthat-warning", "qcthat-condition")
  )
  expect_equal(
    CompileConditionClasses("this_subclass", "message"),
    c("qcthat-message-this_subclass", "qcthat-message", "qcthat-condition")
  )
})

test_that("qcthatAbort creates an error condition with expected classes and message", {
  variable <- "sample"
  test_message <- "This is a test {variable} error message."
  test_condition <- expect_error(
    qcthatAbort(test_message, strErrorSubclass = "test"),
    class = "qcthat-error-test"
  )
  expect_s3_class(test_condition, "qcthat-error")
  expect_s3_class(test_condition, "qcthat-condition")
  expect_equal(test_condition$message, "This is a test sample error message.")
})
