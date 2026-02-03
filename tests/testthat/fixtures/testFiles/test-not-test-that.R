# File that starts like test_that but isn't

test_that_helper <- function(desc, code) {
  # Not a real test_that call
}

test_that_helper("Fake test (#88)", {
  TRUE
})
