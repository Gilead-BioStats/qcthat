test_that("EmptyLabelsDF returns the expected structure (#90)", {
  dfResult <- EmptyLabelsDF()
  expect_s3_class(dfResult, "tbl_df")
  expect_identical(nrow(dfResult), 0L)
  expect_identical(names(dfResult), c("Label", "Description", "Color"))
  expect_type(dfResult$Label, "character")
  expect_type(dfResult$Description, "character")
  expect_type(dfResult$Color, "character")
})

test_that("EnframeGHLabels returns NULL for empty list (#90)", {
  expect_null(EnframeGHLabels(list()))
})

test_that("EnframeGHLabels converts raw labels to data frame (#90)", {
  lGHLabels <- list(
    list(
      name = "bug",
      description = "Something isn't working",
      color = "d73a4a"
    ),
    list(
      name = "enhancement",
      description = "New feature or request",
      color = "a2eeef"
    )
  )
  dfResult <- EnframeGHLabels(lGHLabels)
  expect_s3_class(dfResult, "tbl_df")
  expect_identical(nrow(dfResult), 2L)
  expect_identical(names(dfResult), c("Label", "Description", "Color"))
  expect_identical(dfResult$Label, c("bug", "enhancement"))
  expect_identical(
    dfResult$Description,
    c("Something isn't working", "New feature or request")
  )
  expect_identical(dfResult$Color, c("#d73a4a", "#a2eeef"))
})

test_that("EnframeGHLabels adds hash to color codes (#90)", {
  lGHLabels <- list(
    list(
      name = "test",
      description = "test label",
      color = "123456"
    )
  )
  dfResult <- EnframeGHLabels(lGHLabels)
  expect_identical(dfResult$Color, "#123456")
})

test_that("FetchGHLabelsRaw calls the correct API endpoint (#90)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, strOwner, strRepo, strGHToken) {
      expect_identical(strEndpoint, "GET /repos/{owner}/{repo}/labels")
      expect_identical(strOwner, "test-owner")
      expect_identical(strRepo, "test-repo")
      expect_identical(strGHToken, "test-token")
      list()
    }
  )
  FetchGHLabelsRaw(
    strOwner = "test-owner",
    strRepo = "test-repo",
    strGHToken = "test-token"
  )
})

test_that("FetchGHLabels returns empty data frame when no labels exist (#90)", {
  local_mocked_bindings(
    FetchGHLabelsRaw = function(...) {
      list()
    }
  )
  dfResult <- FetchGHLabels()
  expect_s3_class(dfResult, "tbl_df")
  expect_identical(nrow(dfResult), 0L)
  expect_identical(names(dfResult), c("Label", "Description", "Color"))
})

test_that("FetchGHLabels returns data frame with labels (#90)", {
  local_mocked_bindings(
    FetchGHLabelsRaw = function(...) {
      list(
        list(
          name = "bug",
          description = "Something isn't working",
          color = "d73a4a"
        ),
        list(
          name = "enhancement",
          description = "New feature or request",
          color = "a2eeef"
        )
      )
    }
  )
  dfResult <- FetchGHLabels()
  expect_s3_class(dfResult, "tbl_df")
  expect_identical(nrow(dfResult), 2L)
  expect_identical(dfResult$Label, c("bug", "enhancement"))
  expect_identical(dfResult$Color, c("#d73a4a", "#a2eeef"))
})


