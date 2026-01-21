test_that("TriggerUAT calls MaybeRerunAllQCPRWorkflows if open PRs exist (#114)", {
  local_mocked_bindings(
    FetchAllIssuePRRefs = function(intClosedIssue, strPRState, ...) {
      expect_equal(intClosedIssue, 123)
      expect_equal(strPRState, "open")
      tibble::tibble(PR = 1, HeadRef = "branch", SHA = "sha")
    },
    MaybeRerunAllQCPRWorkflows = function(dfOpenPRRefs, ...) {
      expect_equal(nrow(dfOpenPRRefs), 1)
    }
  )

  TriggerUAT(123)
})

test_that("TriggerUAT does nothing if no open PRs exist (#114)", {
  local_mocked_bindings(
    FetchAllIssuePRRefs = function(...) {
      tibble::tibble(PR = integer(), HeadRef = character(), SHA = character())
    },
    MaybeRerunAllQCPRWorkflows = function(...) {
      stop("Should not be called")
    }
  )

  expect_no_error(TriggerUAT(123))
})

test_that("MaybeRerunAllQCPRWorkflows triggers rerun if conditions met (#114)", {
  local_mocked_bindings(
    FetchRepoIssues = function(...) {
      tibble::tibble(Issue = c(10, 11))
    },
    FetchPRUATCommentIssues = function(intPR, ...) {
      if (intPR == 1) {
        return(c(10, 11))
      } # All closed
      if (intPR == 2) {
        return(c(10, 12))
      } # 12 open (not in list)
      integer()
    },
    MaybeRerunQCPRWorkflow = function(intPRNumber, ...) {
      if (intPRNumber == 1) {
        return(NULL)
      }
      stop("Should only rerun for PR 1")
    }
  )

  dfOpenPRRefs <- tibble::tibble(
    PR = c(1, 2),
    HeadRef = c("b1", "b2"),
    SHA = c("s1", "s2")
  )

  expect_no_error(MaybeRerunAllQCPRWorkflows(dfOpenPRRefs))
})

test_that("FetchPRUATCommentIssues extracts issues correctly (#114)", {
  local_mocked_bindings(
    FetchIssueComments = function(intPRNumber) {
      if (intPRNumber == 1) {
        return(
          tibble::tibble(
            qcthatCommentID = rlang::hash(
              "[{qcthat}](https://gilead-biostats.github.io/qcthat/) Report: User Acceptance"
            ),
            Body = "Check these:\n- https://github.com/org/repo/issues/123\n- https://github.com/org/repo/issues/456"
          )
        )
      }
      if (intPRNumber == 2) {
        return(tibble::tibble(
          qcthatCommentID = character(),
          Body = character()
        ))
      }
      return(tibble::tibble(
        qcthatCommentID = "other",
        Body = "stuff"
      ))
    }
  )
  expect_equal(FetchPRUATCommentIssues(1), c(123, 456))
  expect_null(FetchPRUATCommentIssues(2))
  expect_null(FetchPRUATCommentIssues(3))
})

test_that("MaybeRerunQCPRWorkflow delegates to RerunWorkflowIfFinished (#114)", {
  local_mocked_bindings(
    FetchPRActionRuns = function(...) list(obj = 1),
    RerunWorkflowIfFinished = function(...) TRUE
  )
  expect_true(MaybeRerunQCPRWorkflow(1, "ref", "sha"))
})

test_that("MaybeRerunQCPRWorkflow does nothing if no runs found (#114)", {
  local_mocked_bindings(
    FetchPRActionRuns = function(...) list(),
    RerunWorkflowIfFinished = function(...) stop("Should not be called")
  )
  expect_no_error(MaybeRerunQCPRWorkflow(1, "ref", "sha"))
})

test_that("FetchPRActionRuns calls API and filters correctly (#114)", {
  local_mocked_bindings(
    CallGHAPI = function(...) {
      list(
        workflow_runs = list(
          list(path = "workflows/qcthat-pr_issues.yaml", id = 1),
          list(path = "workflows/other.yaml", id = 2)
        )
      )
    }
  )

  # Filtered
  res <- FetchPRActionRuns(1, "ref", strAction = "qcthat-pr_issues")
  expect_equal(length(res), 1)
  expect_equal(res[[1]]$id, 1)

  # Unfiltered
  res_all <- FetchPRActionRuns(1, "ref")
  expect_equal(length(res_all), 2)
})

test_that("RerunWorkflowIfFinished reruns only if none in progress (#114)", {
  local_mocked_bindings(
    RerunWorkflowAtSHA = function(...) TRUE
  )

  # None in progress
  runs_finished <- list(
    list(status = "completed"),
    list(status = "failure")
  )
  expect_true(RerunWorkflowIfFinished(runs_finished, "sha"))

  # One in progress
  runs_progress <- list(
    list(status = "completed"),
    list(status = "in_progress")
  )
  local_mocked_bindings(
    RerunWorkflowAtSHA = function(...) stop("Should not run")
  )
  expect_no_error(RerunWorkflowIfFinished(runs_progress, "sha"))
})

test_that("RerunWorkflowAtSHA picks correct run (#114)", {
  local_mocked_bindings(
    RerunWorkflow = function(strRunID, ...) {
      expect_equal(strRunID, 2)
    }
  )

  runs <- list(
    list(id = 1, head_sha = "sha1"),
    list(id = 2, head_sha = "sha2"),
    list(id = 3, head_sha = "sha3")
  )

  RerunWorkflowAtSHA(runs, "sha2")
})

test_that("RerunWorkflow calls API correctly (#114)", {
  local_mocked_bindings(
    CallGHAPI = function(endpoint, run_id, ...) {
      expect_match(endpoint, "POST .*rerun")
      expect_equal(run_id, 123)
    }
  )
  RerunWorkflow(123)
})

# This can't actually test until the workflow has been merged, so I'm commenting
# it out, but I'm leaving the code to uncomment in the next PR.

# test_that("The UAT workflow triggers properly when all UAT issues connected to a PR are closed (#157)", {
#   # Manually skip so we can do the `if` below. Consider adding helpers for this situation!
#   skip_if(OnCran())
#   skip_if_not(UsesGit())
#   skip_if_not(IsOnline())
#
#   strUAT1 <- list(
#     description = "The qcthat-uat action triggers report re-run when a single UAT issue is closed",
#     intIssue = 157,
#     chrInstructions = "Close this issue after the initial PR report associated with this functionality runs."
#   )
#
#   qcthat::ExpectUserAccepts(
#     strUAT1$description,
#     intIssue = strUAT1$intIssue,
#     chrInstructions = strUAT1$chrInstructions
#   )
#
#   # Only run this one if the first one is closed.
#   lUAIssue <- with_mocked_bindings(
#     {
#       FetchUAIssue(
#         strUAT1$description,
#         intIssue = strUAT1$intIssue,
#         chrInstructions = strUAT1$chrInstructions
#       )
#     },
#     CreateUAIssue = function(...) list()
#   )
#   if (identical(lUAIssue[["State"]], "closed")) {
#     qcthat::ExpectUserAccepts(
#       "The qcthat-uat action triggers report re-run when all UAT issues are closed",
#       intIssue = 157,
#       chrInstructions = "Close this issue after the PR report for this functionality runs."
#     )
#   }
# })
