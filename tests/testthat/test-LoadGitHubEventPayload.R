test_that("LoadGHEventPayload returns NULL when envvar is empty (#162)", {
  withr::local_envvar(list(GITHUB_EVENT_PATH = ""))
  expect_null(LoadGHEventPayload())
})

test_that("LoadGHEventPayload returns NULL for bad path (#162)", {
  expect_null(LoadGHEventPayload(NULL))
  expect_null(LoadGHEventPayload("thisisnotapathtoarealfile"))
})

test_that("LoadGHEventPayload returns NULL for bad payload (#162)", {
  temp_json_path <- withr::local_tempfile(
    pattern = "gh_event_",
    fileext = ".json"
  )
  lPayload <- list(not_a_payload = TRUE)
  jsonlite::write_json(lPayload, path = temp_json_path)
  expect_null(LoadGHEventPayload(temp_json_path))
})

test_that("LoadGHEventPayload returns the payload if it's readable (#162)", {
  temp_json_path <- withr::local_tempfile(
    pattern = "gh_event_",
    fileext = ".json"
  )
  lPayload <- list(action = "opened", issue = list(number = 42L))
  jsonlite::write_json(lPayload, path = temp_json_path, auto_unbox = TRUE)
  test_result <- LoadGHEventPayload(temp_json_path)
  expect_identical(test_result, lPayload)
})
