test_that("GuessReleaseID returns NULL for bad arg (#152)", {
  expect_null(GuessReleaseID(NULL))
  expect_null(GuessReleaseID(letters))
  expect_null(GuessReleaseID(list()))
})

test_that("GuessReleaseID extracts release from lGHEventPayload when available (#152)", {
  expect_equal(
    GuessReleaseID(list(release = list(id = 42))),
    42
  )
})

test_that("GuessReleaseID converts tag name to release id when necessary (#152)", {
  local_mocked_bindings(
    FetchRawReleaseByTagName = function(strTagName, ...) {
      if (strTagName == "v1.0.0") list(id = 84)
    }
  )
  expect_equal(
    GuessReleaseID(list(inputs = list(tag = "v1.0.0"))),
    84
  )
  expect_null(GuessReleaseID(list(inputs = list(tag = "v2.0.0"))))
  expect_null(GuessReleaseID(list(release = list(tag_name = "v2.0.0"))))
})

test_that("FetchRawReleaseByTagName generates the expected call (#152)", {
  local_mocked_bindings(
    CallGHAPI = function(...) list(...)
  )
  expect_equal(
    FetchRawReleaseByTagName("v1.0.0", "owner", "repo", "token"),
    list(
      "GET /repos/{owner}/{repo}/releases/tags/{tag}",
      tag = "v1.0.0",
      strOwner = "owner",
      strRepo = "repo",
      strGHToken = "token"
    )
  )
})
