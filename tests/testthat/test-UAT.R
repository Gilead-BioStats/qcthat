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

test_that("The pkgdown site has a slide deck (#167)", {
  ExpectUserAccepts(
    "The pkgdown site has a slide deck.",
    intIssue = 167,
    chrInstructions = "Load the website linked in this issue as 'PR pkgdown deployed'.",
    chrChecks = c(
      "The top bar has a 'Slides' menu.",
      "The menu has at least one entry.",
      "Clicking that entry loads a rendered slide deck."
    )
  )
})
