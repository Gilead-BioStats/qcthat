test_that("Default helpers return expected values (#90)", {
  expect_equal(DefaultIgnoreLabels(), c("qcthat-nocov", "qcthat-uat"))
  expect_match(
    DefaultIgnoreLabelDescriptions(),
    "(Do not include)|(user acceptance testing)"
  )

  dfDefaults <- DefaultIgnoreLabelsDF()
  expect_s3_class(dfDefaults, "tbl_df")
  expect_named(dfDefaults, c("Label", "Description", "Color"))
  expect_equal(dfDefaults$Label, c("qcthat-nocov", "qcthat-uat"))
})

test_that("SetupGHLabels creates missing labels (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, ...) {
      args <- list(...)
      if (grepl("GET", strEndpoint)) {
        return(list()) # No existing labels
      } else if (grepl("POST", strEndpoint)) {
        return(list(name = args$name))
      }
    }
  )

  res <- SetupGHLabels(
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )

  expect_type(res, "list")
  expect_equal(res[[1]]$name, "qcthat-nocov")
})

test_that("PrepareDFLabels normalizes correctly (#90)", {
  dfInput <- tibble::tibble(
    Label = c("new", "new2"),
    Description = c("new desc", "new2 desc"),
    Color = c("#000", "#111")
  )

  dfRes <- PrepareDFLabels(
    dfInput,
    strOwner = "o",
    strRepo = "r",
    strGHToken = "t"
  )
  dfExpected <- tibble::tibble(
    Label = c("qcthat-new", "qcthat-new2"),
    Description = c("{qcthat}: new desc", "{qcthat}: new2 desc"),
    Color = c("#000", "#111")
  )

  expect_identical(dfRes, dfExpected)
})

test_that("Helper functions normalize strings correctly (#90)", {
  expect_equal(NormalizeLabelPrefix("foo"), "qcthat-foo")
  expect_equal(NormalizeLabelPrefix("qcthat-foo"), "qcthat-foo")

  expect_equal(NormalizeDescriptionPrefix("bar"), "{qcthat}: bar")
  expect_equal(NormalizeDescriptionPrefix("{qcthat}: bar"), "{qcthat}: bar")
})

test_that("ValidateDFLabels checks for required columns (#90)", {
  dfBad <- tibble::tibble(Label = "foo") # Missing Description, Color
  expect_error(
    ValidateDFLabels(dfBad),
    class = "qcthat-error-invalid_dfLabels"
  )

  dfGood <- tibble::tibble(Label = "a", Description = "b", Color = "c")
  expect_no_error(ValidateDFLabels(dfGood))
})
