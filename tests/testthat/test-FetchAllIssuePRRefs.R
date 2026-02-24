test_that("FetchAllIssuePRRefs returns correct PR information (#114)", {
  local_mocked_bindings(
    FetchAllIssuePRRefsRaw = function(...) {
      list(
        data = list(
          repository = list(
            issue = list(
              timelineItems = list(
                nodes = list(
                  list(
                    source = list(
                      state = "OPEN",
                      number = 101,
                      headRefName = "feature/test",
                      commits = list(
                        nodes = list(
                          list(commit = list(oid = "abc1234"))
                        )
                      )
                    )
                  ),
                  list(
                    source = list(
                      state = "CLOSED",
                      number = 102,
                      headRefName = "feature/old",
                      commits = list(
                        nodes = list(
                          list(commit = list(oid = "def5678"))
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    }
  )

  # Check with default filter (all states)
  res <- FetchAllIssuePRRefs(
    intIssue = 1,
    strOwner = "test_owner",
    strRepo = "test_repo"
  )

  expect_s3_class(res, "tbl_df")
  expect_named(res, c("PR", "State", "HeadRef", "SHA"))
  expect_equal(nrow(res), 2)
  expect_equal(res$PR, c(101, 102))
  expect_equal(res$State, c("open", "closed"))
  expect_equal(res$SHA, c("abc1234", "def5678"))
})

test_that("FetchAllIssuePRRefs filters by state correctly (#114)", {
  local_mocked_bindings(
    FetchAllIssuePRRefsRaw = function(...) {
      list(
        data = list(
          repository = list(
            issue = list(
              timelineItems = list(
                nodes = list(
                  list(
                    source = list(
                      state = "OPEN",
                      number = 101,
                      headRefName = "feature/test",
                      commits = list(
                        nodes = list(
                          list(commit = list(oid = "abc1234"))
                        )
                      )
                    )
                  ),
                  list(
                    source = list(
                      state = "CLOSED",
                      number = 102,
                      headRefName = "feature/old",
                      commits = list(
                        nodes = list(
                          list(commit = list(oid = "def5678"))
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    }
  )

  # Check filtering for "open" only
  res_open <- FetchAllIssuePRRefs(
    intIssue = 1,
    strPRState = "open",
    strOwner = "test_owner",
    strRepo = "test_repo"
  )

  expect_equal(nrow(res_open), 1)
  expect_equal(res_open$State, "open")
  expect_equal(res_open$PR, 101)
})

test_that("FetchAllIssuePRRefsRaw generates the expected calls (#114)", {
  local_mocked_bindings(
    FetchGQL = function(...) list(...)
  )
  expect_snapshot({
    FetchAllIssuePRRefsRaw(
      intIssue = 123,
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
})

test_that("BuildIssuePRRefsQuery generates correct GQL (#114)", {
  expect_snapshot({
    BuildIssuePRRefsQuery(123)
  })
})
