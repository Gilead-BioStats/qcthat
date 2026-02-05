test_that("GuessMilestones returns NULL for bad arg (#165)", {
  expect_null(GuessMilestones(NULL))
  expect_null(GuessMilestones(letters))
  expect_null(GuessMilestones(list()))
})

test_that("GuessMilestones extracts milestones from lGHEventPayload when available (#165)", {
  expect_equal(
    GuessMilestones(
      list(
        pull_request = list(milestone = list(title = "v1.0"))
      )
    ),
    "v1.0"
  )
  expect_setequal(
    GuessMilestones(
      list(release = list(name = "v1.0", tag_name = "1.0"))
    ),
    c("v1.0", "1.0")
  )
  expect_equal(
    GuessMilestones(
      list(release = list(name = "v1.0", tag_name = "v1.0"))
    ),
    "v1.0"
  )
  expect_equal(
    GuessMilestones(
      list(inputs = list(milestone = "v1.0"))
    ),
    "v1.0"
  )
})

test_that("GuessMilestones returns NULL for bad extracted milestones (#165)", {
  expect_null(GuessMilestones(
    list(inputs = list(milestone = NA))
  ))
  expect_null(GuessMilestones(
    list(inputs = list(milestone = ""))
  ))
})
