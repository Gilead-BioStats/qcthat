test_that("FetchRepoIssueClosers returns an empty df when no issues are found (#133)", {
  local_mocked_bindings(
    FetchRepoIssueClosersRaw = function(...) list()
  )
  expect_equal(
    FetchRepoIssueClosers("owner", "repo", "token"),
    tibble::tibble(
      Issue = integer(),
      CloserType = character(),
      CloserSHA = character(),
      CloserPRNumber = integer()
    )
  )
})

test_that("FetchRepoIssueClosers processes raw data correctly (#133)", {
  local_mocked_bindings(
    FetchRepoIssueClosersRawBatch = function(...) {
      list(
        data = list(
          repository = list(
            issues = list(
              nodes = list(
                list(
                  number = 1,
                  timelineItems = list(
                    nodes = list(
                      list(
                        closer = list(
                          `__typename` = "Commit",
                          oid = "abc123"
                        )
                      )
                    )
                  )
                ),
                list(
                  number = 2,
                  timelineItems = list(
                    nodes = list(
                      list(
                        closer = list(
                          `__typename` = "PullRequest",
                          number = 42,
                          merged = TRUE,
                          repository = list(nameWithOwner = "owner/repo")
                        )
                      )
                    )
                  )
                ),
                list(
                  number = 4,
                  timelineItems = list(
                    nodes = list(
                      list(
                        closer = list(
                          `__typename` = "PullRequest",
                          number = 99,
                          merged = TRUE,
                          repository = list(nameWithOwner = "other-owner/other-repo")
                        )
                      )
                    )
                  )
                ),
                list(
                  number = 5,
                  timelineItems = list(
                    nodes = list(
                      list(
                        closer = list(
                          `__typename` = "PullRequest",
                          number = 88,
                          merged = FALSE,
                          repository = list(nameWithOwner = "owner/repo")
                        )
                      )
                    )
                  )
                ),
                list(number = 3)
              ),
              pageInfo = list(
                hasNextPage = FALSE,
                endCursor = NULL
              )
            )
          )
        )
      )
    }
  )
  expected_df <- tibble::tibble(
    Issue = c(1, 2),
    CloserType = c("Commit", "PullRequest"),
    CloserSHA = c("abc123", NA_character_),
    CloserPRNumber = c(NA_integer_, 42)
  )
  expect_equal(
    FetchRepoIssueClosers("owner", "repo", "token"),
    expected_df
  )
})

test_that("FetchRepoIssueClosersRaw processes pagination correctly (#133)", {
  local_mocked_bindings(
    FetchRepoIssueClosersRawBatch = function(
      strOwner,
      strRepo,
      strGHToken,
      strCursor
    ) {
      if (is.null(strCursor)) {
        list(
          data = list(
            repository = list(
              issues = list(
                nodes = list(
                  list(number = 1),
                  list(number = 2)
                ),
                pageInfo = list(
                  hasNextPage = TRUE,
                  endCursor = "cursor1"
                )
              )
            )
          )
        )
      } else if (strCursor == "cursor1") {
        list(
          data = list(
            repository = list(
              issues = list(
                nodes = list(
                  list(number = 3)
                ),
                pageInfo = list(
                  hasNextPage = FALSE,
                  endCursor = NULL
                )
              )
            )
          )
        )
      }
    }
  )
  result <- FetchRepoIssueClosersRaw("owner", "repo", "token")
  expect_equal(length(result), 3)
  expect_equal(result[[1]]$number, 1)
  expect_equal(result[[2]]$number, 2)
  expect_equal(result[[3]]$number, 3)
})

test_that("IsIssueCloserFromRepo filters cross-repo PRs (#133)", {
  make_issue <- function(typename, nameWithOwner = NULL) {
    closer <- list(`__typename` = typename)
    if (!is.null(nameWithOwner)) {
      closer$repository <- list(nameWithOwner = nameWithOwner)
    }
    list(timelineItems = list(nodes = list(list(closer = closer))))
  }

  expect_true(IsIssueCloserFromRepo(make_issue("Commit"), "owner/repo"))
  expect_true(
    IsIssueCloserFromRepo(make_issue("PullRequest", "owner/repo"), "owner/repo")
  )
  expect_false(
    IsIssueCloserFromRepo(
      make_issue("PullRequest", "other-owner/other-repo"), "owner/repo"
    )
  )
})

test_that("FetchRepoIssueClosersRawBatch generates the expected calls (#133)", {
  local_mocked_bindings(
    FetchGQL = function(...) list(...)
  )
  expect_snapshot({
    FetchRepoIssueClosersRawBatch(
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  })
  expect_snapshot({
    FetchRepoIssueClosersRawBatch(
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token",
      strCursor = "not-null"
    )
  })
})
