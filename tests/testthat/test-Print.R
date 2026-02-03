test_that("Printing a generic qcthat_object returns input invisibly (#49)", {
  obj <- structure(
    "Object printed successfully",
    class = c("qcthat_Object", "character")
  )
  # Test print at the same time so the output doesn't show up in the test
  # results.
  expect_unformatted_snapshot({
    # Adds `visible` flag to object
    test_result <- withVisible(print(obj))
  })
  expect_false(test_result$visible)
  expect_identical(test_result$value, obj)
})

test_that("MakeKeyItem works (#60)", {
  expect_unformatted_snapshot({
    MakeKeyItem("open")
  })
})

test_that("ChooseEmoji switches to ASCII if emoji not allowed (#noissue)", {
  expect_identical(
    ChooseEmoji("open", FALSE),
    "[o]"
  )
})

test_that("GetChrCode returns the expected code (#noissue)", {
  expect_identical(
    GetChrCode("box"),
    "\U2588"
  )
})

test_that("FinalizeTree adds tree characters correctly (#49)", {
  lTree <- list("Item 1", "Item 2", "Item 3")
  test_result <- FinalizeTree(lTree)
  expect_snapshot({
    cat(test_result, sep = "\n")
  })
})
