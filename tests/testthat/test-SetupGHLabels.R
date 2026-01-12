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

test_that("SetupGHLabels skips existing labels (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, ...) {
      if (grepl("GET", strEndpoint)) {
        return(list(list(name = "qcthat-nocov"), list(name = "qcthat-uat")))
      } else if (grepl("POST", strEndpoint)) {
        stop("Should not attempt to create label if it exists")
      }
    }
  )

  res <- SetupGHLabels(
    strOwner = "owner",
    strRepo = "repo",
    strGHToken = "token"
  )
  expect_equal(res, list())
})

test_that("PrepareDFLabels normalizes and filters correctly (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, ...) {
      return(list(list(name = "qcthat-existing")))
    }
  )

  dfInput <- tibble::tibble(
    Label = c("new", "existing"),
    Description = c("new desc", "exist desc"),
    Color = c("#000", "#111")
  )

  dfRes <- PrepareDFLabels(
    dfInput,
    strOwner = "o",
    strRepo = "r",
    strGHToken = "t"
  )

  # Should only contain "new", with prefix added
  expect_equal(nrow(dfRes), 1)
  expect_equal(dfRes$Label, "qcthat-new")
  expect_match(dfRes$Description, "^\\{qcthat\\}:")
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

test_that("CreateGHLabel reports success conditional on lglVerbose (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, name, ...) {
      return(list(name = name))
    }
  )
  expect_message(
    {
      CreateGHLabel(
        strLabel = "test-label",
        strLabelDescription = "test description",
        strLabelColor = "#123456",
        strOwner = "o",
        strRepo = "r",
        strGHToken = "t",
        lglVerbose = TRUE
      )
    },
    class = "qcthat-message-create_label"
  )
  expect_no_message({
    CreateGHLabel(
      strLabel = "test-label",
      strLabelDescription = "test description",
      strLabelColor = "#123456",
      strOwner = "o",
      strRepo = "r",
      strGHToken = "t",
      lglVerbose = FALSE
    )
  })
})

test_that("CreateGHLabel throws an error if the API doesn't report the expected result (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, name, ...) {
      return(list()) # Missing 'name' field
    }
  )
  expect_error(
    {
      CreateGHLabel(
        strLabel = "test-label",
        strLabelDescription = "test description",
        strLabelColor = "#123456",
        strOwner = "o",
        strRepo = "r",
        strGHToken = "t"
      )
    },
    class = "qcthat-error-create_label"
  )
})
