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
      "The top bar has a 'Slides' link.",
      "Clicking that entry loads a rendered slide deck."
    )
  )
  qcthat::ExpectUserAccepts(
    "The intro slide deck has appropriate titles.",
    intIssue = 168,
    chrInstructions = paste(
      "1. Load the website linked in the PR attached to this issue as 'PR pkgdown deployed'.",
      "2. Click 'Slides'.",
      "3. Click the hamburger menu (3 lines) at the bottom-left of the deck.",
      sep = "\n"
    ),
    chrChecks = c("The titles make sense for this introduction to qcthat.")
  )
  qcthat::ExpectUserAccepts(
    "The intro slide deck has appropriate slides.",
    intIssue = 169,
    chrInstructions = paste(
      "1. Load the website linked in the PR attached to this issue as 'PR pkgdown deployed'.",
      "2. Click 'Slides'.",
      "3. Move through the deck with arrow keys.",
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
      "1. Load the website linked in the PR attached to this issue as 'PR pkgdown deployed'.",
      "2. Click 'Slides'.",
      "3. Move through the deck with arrow keys.",
      sep = "\n"
    ),
    chrChecks = c(
      "The slides work well for a presentation introducing the PHUSE US 2026 audience to `{qcthat}`."
    )
  )
})

test_that("README is straightforward (#236)", {
  qcthat::ExpectUserAccepts(
    "The README describes the core functionality of qcthat in a straightforward way.",
    intIssue = 236,
    chrInstructions = "Load README.Rmd in the PR attached to this issue, or the website deployed for that issue.",
    chrChecks = c(
      "The README describes the core functionality of qcthat in a straightforward way."
    )
  )
})

test_that("There's a vignette about getting started (#98)", {
  qcthat::ExpectUserAccepts(
    "The website includes a Setup article to get started",
    intIssue = 98,
    chrInstructions = "Load the website linked in the PR attached to this issue as 'PR pkgdown deployed'.",
    chrChecks = c(
      "The website has a 'Setup' article in the top bar.",
      "The 'Setup' article describes how to get started with qcthat."
    )
  )
})

test_that("Vignette exists for ExpectUserAccepts (#293)", {
  qcthat::ExpectUserAccepts(
    strDescription = "The website includes an article how to use ExpectUserAccepts",
    intIssue = 293,
    chrInstructions = "Load the website linked in the PR attached to this issue as 'PR pkgdown deployed'.",
    chrChecks = c(
      "The website has a 'User acceptance testing with ExpectUserAccepts' under Articles.",
      "The 'User acceptance testing with ExpectUserAccepts' article describes how to correctly use ExpectUserAccepts."
    )
  )
})
