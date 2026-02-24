test_that("CreateGHLabel reports success conditional on lglVerbose (#90)", {
  local_mocked_bindings(
    FetchGHLabels = function(...) {
      list(Label = character())
    },
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
    FetchGHLabels = function(...) {
      list(Label = character())
    },
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

test_that("CreateGHLabel attempts to update existing label (#90)", {
  strLabelTest <- "test-label"
  strLabelDescriptionTest <- "test description"
  strLabelColorTest <- "#123456"
  local_mocked_bindings(
    FetchGHLabels = function(...) {
      list(Label = strLabelTest)
    },
    MaybeUpdateGHLabel = function(
      strLabel,
      strLabelDescription,
      strLabelColor,
      lglUpdate,
      lglVerbose,
      strOwner,
      strRepo,
      strGHToken
    ) {
      expect_identical(strLabel, strLabelTest)
      expect_identical(strLabelDescription, strLabelDescriptionTest)
      expect_identical(strLabelColor, strLabelColorTest)
    }
  )
  expect_no_error({
    CreateGHLabel(
      strLabel = strLabelTest,
      strLabelDescription = strLabelDescriptionTest,
      strLabelColor = strLabelColorTest,
      strOwner = "o",
      strRepo = "r",
      strGHToken = "t"
    )
  })
})

test_that("MaybeUpdateGHLabel decides based on lglUpdate (#90)", {
  local_mocked_bindings(
    UpdateGHLabel = function(
      strLabel,
      strLabelNewName,
      strLabelDescription,
      strLabelColor,
      lglUpdate,
      lglVerbose,
      strOwner,
      strRepo,
      strGHToken
    ) {
      TRUE
    }
  )
  expect_true(MaybeUpdateGHLabel(lglUpdate = TRUE))
  expect_error(
    {
      MaybeUpdateGHLabel(strLabel = "test-label", lglUpdate = FALSE)
    },
    class = "qcthat-error-label_exists"
  )
})

test_that("UpdateGHLabel makes the expected call (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, name, ...) {
      expect_equal(strEndpoint, "PATCH /repos/{owner}/{repo}/labels/{name}")
      expect_equal(name, "test-label")
      return(list(name = name))
    }
  )
  expect_message(
    {
      UpdateGHLabel(
        strLabel = "test-label",
        strLabelDescription = "test description",
        strLabelColor = "#123456",
        strOwner = "o",
        strRepo = "r",
        strGHToken = "t",
        lglVerbose = TRUE
      )
    },
    class = "qcthat-message-update_label"
  )
  expect_no_message({
    UpdateGHLabel(
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

test_that("UpdateGHLabel throws an error if the API doesn't report the expected result (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, name, ...) {
      return(list()) # Missing 'name' field
    }
  )
  expect_error(
    {
      UpdateGHLabel(
        strLabel = "test-label",
        strLabelDescription = "test description",
        strLabelColor = "#123456",
        strOwner = "o",
        strRepo = "r",
        strGHToken = "t"
      )
    },
    class = "qcthat-error-update_label"
  )
})
