test_that("GetGHRemote handles dots in repo names (#248)", {
  local_mocked_bindings(
    GetGHRemoteList = function(strPkgRoot) {
      tibble::tibble(
        name = c("origin", "upstream"),
        url = c(
          "https://github.com/Org/gsm.reporting.git",
          "https://github.com/OrgUpstream/gsm.reporting.git"
        )
      )
    },
    UsesGit = function(strPkgRoot) TRUE
  )
  expect_identical(
    GetGHRemote("path"),
    list(username = "OrgUpstream", repo = "gsm.reporting")
  )
  local_mocked_bindings(
    GetGHRemoteList = function(strPkgRoot) {
      tibble::tibble(
        name = "origin",
        url = "https://github.com/Org/gsm.reporting.git"
      )
    }
  )
  expect_identical(
    GetGHRemote("path"),
    list(username = "Org", repo = "gsm.reporting")
  )
})

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

test_that("EmptyGHResponse builds an empty GitHub response (#230)", {
  expect_s3_class(EmptyGHResponse(), "gh_response")
  expect_type(EmptyGHResponse(), "list")
  expect_length(EmptyGHResponse(), 0)
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

test_that("FetchVectorFromGQL batches GHGQL calls (#noissue)", {
  local_mocked_bindings(
    FetchGQL = function(strQuery, ...) {
      list(
        batch = stringr::str_replace_all(strQuery, "\\n", "|")
      )
    }
  )
  queryBuilder <- function(vecBatch) {
    expect_lte(length(vecBatch), 3)
    paste0("q", vecBatch)
  }
  test_result <- FetchVectorFromGQL(
    1:10,
    fnBuildQuery = queryBuilder,
    intBatchSize = 3
  )
  expect_equal(
    test_result,
    sort(c("q1|q2|q3", "q4|q5|q6", "q7|q8|q9", "q10"))
  )
  expect_equal(
    FetchVectorFromGQL(character(), queryBuilder),
    integer()
  )
})
