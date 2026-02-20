test_that("GetGHRemote uses upstream when available (#199)", {
  local_mocked_bindings(
    GetGHRemoteList = function(strPkgRoot) {
      tibble::tibble(
        name = c("origin", "upstream"),
        url = glue::glue("https://github.com/{.data$name}/repo.git")
      )
    },
    UsesGit = function(strPkgRoot) TRUE
  )
  expect_identical(
    GetGHRemote("path"),
    list(username = "upstream", repo = "repo")
  )
  local_mocked_bindings(
    GetGHRemoteList = function(strPkgRoot) {
      tibble::tibble(
        name = "origin",
        url = glue::glue("https://github.com/{.data$name}/repo.git")
      )
    }
  )
  expect_identical(
    GetGHRemote("path"),
    list(username = "origin", repo = "repo")
  )
})

test_that("GetGHOwner and GetGHRepo work (#110)", {
  local_mocked_bindings(
    GetGHRemote = function(...) {
      list(
        username = "test_owner",
        repo = "test_repo"
      )
    }
  )
  expect_identical(GetGHOwner(), "test_owner")
  expect_identical(GetGHRepo(), "test_repo")
})

test_that("UsesGit works in any situation (#110)", {
  expect_false(UsesGit("fake_dir"))
})

test_that("PrepareGQLQuery constructs a query (#84)", {
  expect_snapshot({
    PrepareGQLQuery(
      "line 1: <strVar>",
      "line 2",
      strVar = "test_value"
    )
  })
  expect_snapshot({
    PrepareGQLQuery(
      "line 1: {{strVar}}",
      "line 2",
      strOpen = "{{",
      strClose = "}}",
      strVar = "test_value"
    )
  })
})

test_that("GQLWrapper wraps a query correctly (#84)", {
  expect_snapshot({
    GQLWrapper(
      strQuery = "sub-query",
      strOwner = "owner",
      strRepo = "repo"
    )
  })
})
