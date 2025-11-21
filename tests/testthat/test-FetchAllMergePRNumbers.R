test_that("FetchAllMergePRNumbers returns unique, sorted PR numbers (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        commit1 = list(
          associatedPullRequests = list(
            nodes = list(list(number = 101), list(number = 102))
          )
        ),
        commit2 = list(
          associatedPullRequests = list(
            nodes = list(list(number = 102), list(number = 103))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllMergePRNumbers(c("sha1", "sha2")),
    c(101, 102, 103)
  )
})

test_that("FetchAllMergePRNumbers returns empty vector for no SHAs (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) stop("FetchGQL should not be called")
  )
  expect_equal(
    FetchAllMergePRNumbers(character(0)),
    integer(0)
  )
})

test_that("FetchAllMergePRNumbers returns empty vector for no matching PRs (#84)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(commit1 = list(associatedPullRequests = list(nodes = list())))
    }
  )
  expect_equal(
    FetchAllMergePRNumbers("sha1"),
    integer(0)
  )
})

test_that("BuildCommitPRQuery creates the correct sub-query (#84)", {
  expect_snapshot({
    BuildCommitPRQuery("abc123def", 1)
  })
})
