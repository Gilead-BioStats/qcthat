# This test file deals with issues that don't have clean associations with
# functions in the package.

test_that("The required R version is within the normal support window (#146)", {
  ExpectUserAccepts(
    "`R-CMD-check.yaml` runs successfully for old R versions.",
    intIssue = 146,
    chrChecks = c(
      "The `R-CMD-check/ubuntu-latest (oldrel-4)` action runs.",
      "The `R-CMD-check/ubuntu-latest (oldrel-4)` action passes."
    )
  )
})
