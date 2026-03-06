test_that("BuildPRCommitsFragment produces aliased GraphQL fragment (#noissue)", {
  result <- BuildPRCommitsFragment(42L)
  expect_match(result, "pr42: pullRequest\\(number: 42\\)")
  expect_match(result, "commits\\(first: 100\\)")
  expect_match(result, "pageInfo")
})

test_that("BuildPRCommitsFragmentPaginated includes cursor (#noissue)", {
  result <- BuildPRCommitsFragmentPaginated(42L, "abc123cursor")
  expect_match(result, 'after: "abc123cursor"')
  expect_match(result, "pullRequest\\(number: 42\\)")
})

test_that("ExtractPRCommitSHAs returns OIDs from single page (#noissue)", {
  lPRData <- list(
    commits = list(
      nodes = list(
        list(commit = list(oid = "sha-a")),
        list(commit = list(oid = "sha-b")),
        list(commit = list(oid = "sha-c"))
      ),
      pageInfo = list(hasNextPage = FALSE, endCursor = NULL)
    )
  )
  result <- ExtractPRCommitSHAs(lPRData, 42L)
  expect_equal(result, c("sha-a", "sha-b", "sha-c"))
})

test_that("ExtractPRCommitSHAs paginates when hasNextPage is TRUE (#noissue)", {
  intCallCount <- 0L
  local_mocked_bindings(
    FetchGQL = function(strQuery, ...) {
      intCallCount <<- intCallCount + 1L
      list(
        data = list(
          repository = list(
            pullRequest = list(
              commits = list(
                nodes = list(list(
                  commit = list(oid = paste0("page2-sha-", intCallCount))
                )),
                pageInfo = list(hasNextPage = FALSE, endCursor = NULL)
              )
            )
          )
        )
      )
    }
  )
  lPRData <- list(
    commits = list(
      nodes = list(
        list(commit = list(oid = "page1-sha-1")),
        list(commit = list(oid = "page1-sha-2"))
      ),
      pageInfo = list(hasNextPage = TRUE, endCursor = "cursor1")
    )
  )
  result <- ExtractPRCommitSHAs(lPRData, 42L)
  expect_equal(intCallCount, 1L)
  expect_equal(result, c("page1-sha-1", "page1-sha-2", "page2-sha-1"))
})

test_that("FetchAllPRCommitSHAs returns empty list for empty input (#251)", {
  result <- FetchAllPRCommitSHAs(integer())
  expect_equal(result, list())
})

test_that("FetchAllPRCommitSHAs batches PRs and returns one element per PR (#251)", {
  intCallCount <- 0L
  local_mocked_bindings(
    FetchPRCommitSHAsBatch = function(intPRNumbers, ...) {
      intCallCount <<- intCallCount + 1L
      purrr::map(intPRNumbers, ~ paste0("commit-for-pr-", .x))
    }
  )
  # 30 PRs: should split into 2 batches of 25 each
  result <- FetchAllPRCommitSHAs(1L:30L)
  expect_equal(intCallCount, 2L)
  expect_length(result, 30L)
  expect_equal(result[[1]], "commit-for-pr-1")
  expect_equal(result[[30]], "commit-for-pr-30")
})

test_that("FetchPRCommitSHAsBatch returns empty character for missing PR in response (#noissue)", {
  local_mocked_bindings(
    FetchGQL = function(strQuery, ...) {
      # PR 10 is present; PR 20 is absent from the response
      list(
        data = list(
          repository = list(
            pr10 = list(
              commits = list(
                nodes = list(list(commit = list(oid = "sha-10a"))),
                pageInfo = list(hasNextPage = FALSE)
              )
            )
          )
        )
      )
    }
  )
  result <- FetchPRCommitSHAsBatch(c(10L, 20L))
  expect_equal(result[[1]], "sha-10a")
  expect_equal(result[[2]], character())
})

test_that("FetchPRCommitSHAsBatch builds batched query and extracts commits per PR (#noissue)", {
  local_mocked_bindings(
    FetchGQL = function(strQuery, ...) {
      # Verify batch query aliases are present
      expect_match(strQuery, "pr10: pullRequest")
      expect_match(strQuery, "pr20: pullRequest")
      list(
        data = list(
          repository = list(
            pr10 = list(
              commits = list(
                nodes = list(
                  list(commit = list(oid = "sha-10a")),
                  list(commit = list(oid = "sha-10b"))
                ),
                pageInfo = list(hasNextPage = FALSE)
              )
            ),
            pr20 = list(
              commits = list(
                nodes = list(
                  list(commit = list(oid = "sha-20a"))
                ),
                pageInfo = list(hasNextPage = FALSE)
              )
            )
          )
        )
      )
    }
  )
  result <- FetchPRCommitSHAsBatch(c(10L, 20L))
  expect_length(result, 2L)
  expect_equal(result[[1]], c("sha-10a", "sha-10b"))
  expect_equal(result[[2]], "sha-20a")
})
