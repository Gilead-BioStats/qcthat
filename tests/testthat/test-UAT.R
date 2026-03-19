# This test file deals with issues that don't have clean associations with
# functions in the package.

test_that("The required R version is within the normal support window (#146)", {
  qcthat::ExpectUserAccepts(
    "`R-CMD-check.yaml` runs successfully for old R versions.",
    intIssue = 146,
    chrChecks = c(
      "The `R-CMD-check/ubuntu-latest (oldrel-4)` action runs.",
      "The `R-CMD-check/ubuntu-latest (oldrel-4)` action passes."
    )
  )
})

test_that("The pkgdown site has an intro slide deck (#166, #167, #168, #169)", {
  qcthat::ExpectUserAccepts(
    "The pkgdown site has a slide deck.",
    intIssue = 167,
    chrInstructions = "Load the website linked in this issue as 'PR pkgdown deployed'.",
    chrChecks = c(
      "The top bar has a 'Slides' menu.",
      "The menu has at least one entry.",
      "Clicking that entry loads a rendered slide deck."
    )
  )
  qcthat::ExpectUserAccepts(
    "The intro slide deck has appropriate titles.",
    intIssue = 168,
    chrInstructions = paste(
      "1. Load the website linked in this issue as 'PR pkgdown deployed'.",
      "2. Open the 'Slides' menu.",
      "3. Click the deck titled 'Introduction'",
      "4. Click the hamburger menu (3 lines) at the bottom-left of the deck.",
      sep = "\n"
    ),
    chrChecks = c("The titles make sense for this introduction to qcthat.")
  )
  qcthat::ExpectUserAccepts(
    "The intro slide deck has appropriate slides.",
    intIssue = 169,
    chrInstructions = paste(
      "1. Load the website linked in this issue as 'PR pkgdown deployed'.",
      "2. Open the 'Slides' menu.",
      "3. Click the deck titled 'Introduction'.",
      "4. Move through the deck with arrow keys.",
      sep = "\n"
    ),
    chrChecks = c("The slides make sense as an introduction to qcthat.")
  )
})

test_that("The intro slide deck is ready to present (#170)", {
  qcthat::ExpectUserAccepts(
    "The intro slide deck is complete",
    intIssue = 170,
    chrInstructions = paste(
      "1. Load the website linked in this issue as 'PR pkgdown deployed'.",
      "2. Open the 'Slides' menu.",
      "3. Click the deck titled 'Introduction'.",
      "4. Move through the deck with arrow keys.",
      sep = "\n"
    ),
    chrChecks = c(
      "The slides work well for a presentation introducing the PHUSE US 2026 audience to `{qcthat}`."
    )
  )
})
