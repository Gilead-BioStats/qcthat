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
      CloserPRNumber = integer(),
      CloserDate = character()
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
                          mergeCommit = list(oid = "merge42sha"),
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
                          repository = list(
                            nameWithOwner = "other-owner/other-repo"
                          )
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
    CloserSHA = c("abc123", "merge42sha"),
    CloserPRNumber = c(NA_integer_, 42L),
    CloserDate = c(NA_character_, NA_character_)
  )
  expect_equal(
    FetchRepoIssueClosers("owner", "repo", "token"),
    expected_df
  )
})

test_that("FetchRepoIssueClosersRaw processes pagination correctly (#133)", {
  local_mocked_bindings(
    IsIssueCloserFromRepo = function(...) TRUE,
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
                nodes = list(list(number = 1), list(number = 2)),
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
                nodes = list(list(number = 3)),
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
      make_issue("PullRequest", "other-owner/other-repo"),
      "owner/repo"
    )
  )
})

test_that("IsIssueCloserFromRepo filters ConnectedEvent and DisconnectedEvent by repo (#243)", {
  make_connected_issue <- function(typename, nameWithOwner = NULL) {
    subject <- list(`__typename` = "PullRequest", number = 1L)
    if (!is.null(nameWithOwner)) {
      subject$repository <- list(nameWithOwner = nameWithOwner)
    }
    list(timelineItems = list(nodes = list(list(
      `__typename` = typename,
      subject = subject
    ))))
  }

  make_connected_non_pr_issue <- function() {
    list(timelineItems = list(nodes = list(list(
      `__typename` = "ConnectedEvent",
      subject = list(`__typename` = "Issue", number = 1L)
    ))))
  }

  expect_true(
    IsIssueCloserFromRepo(
      make_connected_issue("ConnectedEvent", "owner/repo"),
      "owner/repo"
    )
  )
  expect_false(
    IsIssueCloserFromRepo(make_connected_non_pr_issue(), "owner/repo")
  )
  expect_false(
    IsIssueCloserFromRepo(
      make_connected_issue("ConnectedEvent", "other-owner/other-repo"),
      "owner/repo"
    )
  )
  expect_false(
    IsIssueCloserFromRepo(
      make_connected_issue("DisconnectedEvent", "owner/repo"),
      "owner/repo"
    )
  )
})

test_that("TibblifyIssueCloser returns NULL for non-Commit/PR closers like ProjectV2 (#243)", {
  lIssueCloser <- list(
    number = 30L,
    timelineItems = list(
      nodes = list(
        list(
          createdAt = "2024-02-01T00:00:00Z",
          closer = list(`__typename` = "ProjectV2")
        )
      )
    )
  )
  expect_null(TibblifyIssueCloser(lIssueCloser))
})

test_that("TibblifyIssueCloser treats ConnectedEvent with merged PR as a closer (#243)", {
  lIssueCloser <- list(
    number = 30L,
    timelineItems = list(
      nodes = list(
        list(
          `__typename` = "ConnectedEvent",
          createdAt = "2025-05-30T00:00:00Z",
          subject = list(
            `__typename` = "PullRequest",
            number = 34L,
            merged = TRUE,
            mergeCommit = list(oid = "pr34sha"),
            repository = list(nameWithOwner = "owner/repo")
          )
        )
      )
    )
  )
  expect_equal(
    TibblifyIssueCloser(lIssueCloser),
    tibble::tibble(
      Issue = 30L,
      CloserType = "PullRequest",
      CloserSHA = "pr34sha",
      CloserPRNumber = 34L,
      CloserDate = "2025-05-30T00:00:00Z"
    )
  )
})

test_that("TibblifyIssueCloser annihilates ConnectedEvent with subsequent DisconnectedEvent (#243)", {
  lIssueCloser <- list(
    number = 30L,
    timelineItems = list(
      nodes = list(
        list(
          `__typename` = "ConnectedEvent",
          createdAt = "2025-05-30T00:00:00Z",
          subject = list(
            `__typename` = "PullRequest",
            number = 34L,
            merged = TRUE,
            mergeCommit = list(oid = "pr34sha"),
            repository = list(nameWithOwner = "owner/repo")
          )
        ),
        list(
          `__typename` = "DisconnectedEvent",
          createdAt = "2025-06-01T00:00:00Z",
          subject = list(`__typename` = "PullRequest", number = 34L)
        )
      )
    )
  )
  expect_null(TibblifyIssueCloser(lIssueCloser))
})

test_that("TibblifyIssueCloser handles partial annihilation with multiple ConnectedEvents (#243)", {
  lIssueCloser <- list(
    number = 30L,
    timelineItems = list(
      nodes = list(
        list(
          `__typename` = "ConnectedEvent",
          createdAt = "2025-05-28T00:00:00Z",
          subject = list(
            `__typename` = "PullRequest",
            number = 34L,
            merged = TRUE,
            mergeCommit = list(oid = "pr34sha"),
            repository = list(nameWithOwner = "owner/repo")
          )
        ),
        list(
          `__typename` = "DisconnectedEvent",
          createdAt = "2025-05-29T00:00:00Z",
          subject = list(`__typename` = "PullRequest", number = 34L)
        ),
        list(
          `__typename` = "ConnectedEvent",
          createdAt = "2025-05-30T00:00:00Z",
          subject = list(
            `__typename` = "PullRequest",
            number = 34L,
            merged = TRUE,
            mergeCommit = list(oid = "pr34sha"),
            repository = list(nameWithOwner = "owner/repo")
          )
        )
      )
    )
  )
  # One disconnect cancels one connect; the second connect still survives.
  # CloserDate reflects the most recent ConnectedEvent for that PR.
  expect_equal(
    TibblifyIssueCloser(lIssueCloser),
    tibble::tibble(
      Issue = 30L,
      CloserType = "PullRequest",
      CloserSHA = "pr34sha",
      CloserPRNumber = 34L,
      CloserDate = "2025-05-30T00:00:00Z"
    )
  )
})

test_that(
  "FetchRepoIssueClosers skips non-tibblifiable closers and returns all valid closers (#243)",
  {
    local_mocked_bindings(
      FetchRepoIssueClosersRawBatch = function(...) {
        list(
          data = list(
            repository = list(
              issues = list(
                nodes = list(
                  list(
                    number = 30L,
                    timelineItems = list(
                      nodes = list(
                        # Most recent: ProjectV2 ClosedEvent — not a valid closer
                        list(
                          createdAt = "2024-02-01T00:00:00Z",
                          closer = list(`__typename` = "ProjectV2")
                        ),
                        # Older: ConnectedEvent with a merged PR
                        list(
                          `__typename` = "ConnectedEvent",
                          createdAt = "2024-01-01T00:00:00Z",
                          subject = list(
                            `__typename` = "PullRequest",
                            number = 34L,
                            merged = TRUE,
                            mergeCommit = list(oid = "pr34sha"),
                            repository = list(nameWithOwner = "owner/repo")
                          )
                        )
                      )
                    )
                  )
                ),
                pageInfo = list(hasNextPage = FALSE, endCursor = NULL)
              )
            )
          )
        )
      }
    )
    expect_equal(
      FetchRepoIssueClosers("owner", "repo", "token"),
      tibble::tibble(
        Issue = 30L,
        CloserType = "PullRequest",
        CloserSHA = "pr34sha",
        CloserPRNumber = 34L,
        CloserDate = "2024-01-01T00:00:00Z"
      )
    )
  }
)

test_that("FetchRepoIssueClosers returns all valid closers when an issue has multiple (#243)", {
  local_mocked_bindings(
    FetchRepoIssueClosersRawBatch = function(...) {
      list(
        data = list(
          repository = list(
            issues = list(
              nodes = list(
                list(
                  number = 30L,
                  timelineItems = list(
                    nodes = list(
                      # ClosedEvent with a commit (e.g. first close)
                      list(
                        createdAt = "2024-01-01T00:00:00Z",
                        closer = list(
                          `__typename` = "Commit",
                          oid = "abc123"
                        )
                      ),
                      # ConnectedEvent with a merged PR (e.g. later reconnect)
                      list(
                        `__typename` = "ConnectedEvent",
                        createdAt = "2024-02-01T00:00:00Z",
                        subject = list(
                          `__typename` = "PullRequest",
                          number = 34L,
                          merged = TRUE,
                          mergeCommit = list(oid = "pr34sha"),
                          repository = list(nameWithOwner = "owner/repo")
                        )
                      )
                    )
                  )
                )
              ),
              pageInfo = list(hasNextPage = FALSE, endCursor = NULL)
            )
          )
        )
      )
    }
  )
  expect_equal(
    FetchRepoIssueClosers("owner", "repo", "token"),
    tibble::tibble(
      Issue = c(30L, 30L),
      CloserType = c("PullRequest", "Commit"),
      CloserSHA = c("pr34sha", "abc123"),
      CloserPRNumber = c(34L, NA_integer_),
      CloserDate = c("2024-02-01T00:00:00Z", "2024-01-01T00:00:00Z")
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
