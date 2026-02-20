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
  result <- ResolvePRCommits("ghost-sha", chrAllCommits, envIdx, character())
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

test_that("BuildCommitIndexEnv maps SHAs to correct positions (#noissue)", {
  chrCommits <- c("sha-a", "sha-b", "sha-c")
  envIdx <- BuildCommitIndexEnv(chrCommits)
  expect_equal(envIdx[["sha-a"]], 1L)
  expect_equal(envIdx[["sha-b"]], 2L)
  expect_equal(envIdx[["sha-c"]], 3L)
  expect_null(envIdx[["sha-missing"]])
})
