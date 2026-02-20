test_that("QCMergeGH filters to merge-associated issues (#68, #84)", {
  local_mocked_bindings(
    FetchMergeCommitSHAs = function(strSourceRef, strTargetRef, ...) {
      expect_equal(strSourceRef, "source")
      expect_equal(strTargetRef, "target")
      c("sha1", "sha2")
    },
    FetchAllMergePRNumbers = function(chrCommitSHAs, ...) {
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
      c(101, 102)
    },
    FetchAllPRIssueNumbers = function(...) integer(),
    FetchAllMergeIssueNumbers = function(intPRNumbers, chrCommitSHAs, ...) {
      expect_equal(intPRNumbers, c(101, 102))
      expect_equal(chrCommitSHAs, c("sha1", "sha2"))
      c(1, 2, 3)
    },
    QCIssues = function(intIssues, ...) {
      expect_equal(intIssues, c(1, 2, 3))
      "Final Report"
    }
  )
  expect_identical(
    QCMergeGH(strSourceRef = "source", strTargetRef = "target"),
    "Final Report"
  )
})

test_that("FetchMergeCommitSHAs returns unique, sorted SHAs (#84, #133)", {
  local_mocked_bindings(
    CallGHAPI = function(strEndpoint, source, page = 1, ...) {
      if (source == "source") {
        return(
          list(
            commits = list(
              list(sha = "abc"),
              list(sha = "def"),
              list(sha = "abc"),
              list(sha = "123")
            ),
            total_commits = 4L
          )
        )
      }
      if (source == "source2") {
        if (page == 1) {
          return(
            list(
              commits = list(list(sha = "abc"), list(sha = "def")),
              total_commits = 3L
            )
          )
        }
        return(list(commits = list()))
      }
      if (source == "source3") {
        if (page == 1) {
          return(
            list(
              commits = list(list(sha = "abc"), list(sha = "def")),
              total_commits = 3L
            )
          )
        }
        return(list(commits = list(list(sha = "ghi"))))
      }
      return(list(commits = list(), total_commits = 0L))
    }
  )
  expect_equal(FetchMergeCommitSHAs("source", "target"), c("123", "abc", "def"))
  expect_equal(FetchMergeCommitSHAs("source2", "target"), c("abc", "def"))
  expect_equal(
    FetchMergeCommitSHAs("source3", "target"),
    c("abc", "def", "ghi")
  )
  expect_equal(FetchMergeCommitSHAs("other", "target"), character())
})

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
  expect_equal(
    FetchAllMergePRNumbers(character()),
    integer()
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
    integer()
  )
})

test_that("BuildCommitPRQuery builds the expected query (#133)", {
  expect_snapshot({
    BuildCommitPRQuery(c("sha1", "sha2"))
  })
})

test_that("FetchAllPRIssueNumbers returns unique, sorted issue numbers (#133)", {
  local_mocked_bindings(
    FetchGQL = function(...) {
      list(
        pr101 = list(
          issues = list(
            nodes = list(list(number = 3), list(number = 1))
          )
        ),
        pr102 = list(
          issues = list(
            nodes = list(list(number = 2), list(number = 3))
          )
        )
      )
    }
  )
  expect_equal(
    FetchAllPRIssueNumbers(c(101, 102)),
    1:3
  )
  expect_equal(
    FetchAllPRIssueNumbers(integer()),
    integer()
  )
})

test_that("BuildPRIssuesQuery builds the expected query (#133)", {
  expect_snapshot({
    BuildPRIssuesQuery(c("sha1", "sha2"))
  })
})

test_that("FetchAllMergeIssueNumbers returns unique, sorted issue numbers (#149)", {
  local_mocked_bindings(
    FetchRepoIssueClosers = function(...) {
      tibble::tibble(
        Issue = 1:5,
        CloserType = c(
          "PullRequest",
          "PullRequest",
          "Commit",
          "Commit",
          "PullRequest"
        ),
        CloserSHA = c(NA, NA, "sha1", "sha2", NA),
        CloserPRNumber = c(101, 102, NA, NA, 103)
      )
    }
  )
  expect_equal(
    FetchAllMergeIssueNumbers(c(101, 102), c("sha1")),
    1:3
  )
  expect_equal(
    FetchAllMergeIssueNumbers(integer(), character()),
    integer()
  )
})

test_that("BuildCommitIndexEnv maps SHAs to correct positions (#noissue)", {
  chrCommits <- c("sha-a", "sha-b", "sha-c")
  envIdx <- BuildCommitIndexEnv(chrCommits)
  expect_equal(envIdx[["sha-a"]], 1L)
  expect_equal(envIdx[["sha-b"]], 2L)
  expect_equal(envIdx[["sha-c"]], 3L)
  expect_null(envIdx[["sha-missing"]])
})

test_that("ResolvePRCommits returns squash SHA for a single-parent commit (#noissue)", {
  chrAllCommits <- c("squash-sha", "parent-sha-1", "older-sha")
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  result <- ResolvePRCommits(
    "squash-sha",
    chrAllCommits,
    envIdx,
    "parent-sha-1"
  )
  expect_equal(result, "squash-sha")
})

test_that("ResolvePRCommits returns PR branch commits for a true merge (#noissue)", {
  # Log (most recent first): merge, PR commits, then target parent, then older.
  # parent2 is "pr-commit-a" (pos 2); target parent is at pos 4.
  # Expected slice: positions 2:3 = c("pr-commit-a", "pr-commit-b").
  chrAllCommits <- c(
    "merge-sha",
    "pr-commit-a",
    "pr-commit-b",
    "target-parent",
    "older-sha"
  )
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  result <- ResolvePRCommits(
    "merge-sha",
    chrAllCommits,
    envIdx,
    c("target-parent", "pr-commit-a")
  )
  expect_equal(result, c("pr-commit-a", "pr-commit-b"))
})

test_that("ResolvePRCommits falls back to merge SHA when commit not found locally (#noissue)", {
  chrAllCommits <- c("some-sha", "other-sha")
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  # character(0) parents = SHA not in local repo (e.g. squash-merge ghost SHA)
  result <- ResolvePRCommits("ghost-sha", chrAllCommits, envIdx, character(0))
  expect_equal(result, "ghost-sha")
})

test_that("ResolvePRCommits falls back to merge SHA when PR parent not in log (#noissue)", {
  chrAllCommits <- c("merge-sha", "target-parent", "older-sha")
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  result <- ResolvePRCommits(
    "merge-sha",
    chrAllCommits,
    envIdx,
    c("target-parent", "unknown-pr-tip")
  )
  expect_equal(result, "merge-sha")
})

test_that("ResolvePRCommits falls back to merge SHA when target parent not in log (#noissue)", {
  # PR parent is in the log but target parent is not (e.g. a shallow clone).
  chrAllCommits <- c("merge-sha", "pr-commit-a", "older-sha")
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  result <- ResolvePRCommits(
    "merge-sha",
    chrAllCommits,
    envIdx,
    c("unknown-target", "pr-commit-a")
  )
  expect_equal(result, "merge-sha")
})

test_that("ResolvePRCommits falls back to merge SHA when PR parent is not ahead of target (#noissue)", {
  # intPRPos >= intTargetPos: target is at pos 2, PR tip also at pos 2 or later.
  chrAllCommits <- c("merge-sha", "shared-sha", "older-sha")
  envIdx <- BuildCommitIndexEnv(chrAllCommits)
  result <- ResolvePRCommits(
    "merge-sha",
    chrAllCommits,
    envIdx,
    c("shared-sha", "shared-sha")
  )
  expect_equal(result, "merge-sha")
})

test_that("FetchAllMergeCommitSHAsLocal returns empty list for empty input (#noissue)", {
  result <- FetchAllMergeCommitSHAsLocal(character())
  expect_equal(result, list())
})

test_that("FetchAllMergeCommitSHAsLocal batches multiple merge SHAs in one log call (#noissue)", {
  intLogCallCount <- 0L
  local_mocked_bindings(
    GetGitLog = function(strGitRef, strPkgRoot, intMaxCommits) {
      intLogCallCount <<- intLogCallCount + 1L
      tibble::tibble(
        commit = c(
          "merge-1",
          "pr-a",
          "pr-b",
          "target-1",
          "merge-2",
          "pr-c",
          "target-2"
        ),
        merge = c(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)
      )
    },
    BatchLookupCommitParents = function(chrSHAs, strPkgRoot) {
      # parent2 is the PR branch tip (most recent PR commit in the log)
      lapply(chrSHAs, function(sha) {
        if (sha == "merge-1") {
          c("target-1", "pr-a")
        } else if (sha == "merge-2") {
          c("target-2", "pr-c")
        } else {
          "single-parent"
        }
      })
    }
  )
  result <- FetchAllMergeCommitSHAsLocal(c("merge-1", "merge-2"))
  # git_log should have been called exactly once
  expect_equal(intLogCallCount, 1L)
  # merge-1: pr-a (pos 2) to target-1 (pos 4) exclusive => c("pr-a", "pr-b")
  expect_equal(result[[1]], c("pr-a", "pr-b"))
  # merge-2: pr-c (pos 6) to target-2 (pos 7) exclusive => c("pr-c")
  expect_equal(result[[2]], c("pr-c"))
})
