test_that("use_qcthat calls the expected functions (#161)", {
  dfLabelsTest <- "labels"
  lglOverwriteTest <- "overwrite"
  strPkgRootTest <- "root"
  strOwnerTest <- "owner"
  strRepoTest <- "repo"
  strGHTokenTest <- "token"
  local_mocked_bindings(
    SetupGHLabels = function(dfLabels, strOwner, strRepo, strGHToken) {
      expect_identical(dfLabels, dfLabelsTest)
      expect_identical(strOwner, strOwnerTest)
      expect_identical(strRepo, strRepoTest)
      expect_identical(strGHToken, strGHTokenTest)
      cli::cli_inform("Called SetupGHLabels")
    },
    Action_qcthat = function(lglOverwrite, strPkgRoot) {
      expect_identical(lglOverwrite, lglOverwriteTest)
      expect_identical(strPkgRoot, strPkgRootTest)
      cli::cli_inform("Called Action_qcthat")
    }
  )
  use_qcthat(
    dfLabels = dfLabelsTest,
    lglOverwrite = lglOverwriteTest,
    strPkgRoot = strPkgRootTest,
    strOwner = strOwnerTest,
    strRepo = strRepoTest,
    strGHToken = strGHTokenTest
  ) |>
    expect_true() |>
    expect_message("Called SetupGHLabels") |>
    expect_message("Called Action_qcthat")
})
