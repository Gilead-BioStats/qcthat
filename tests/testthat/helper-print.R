# Turn off "subtle" formatting from pillar for snapshot tests.
expect_unformatted_snapshot <- function(x, call = rlang::caller_env()) {
  withr::local_options(
    pillar.subtle = FALSE,
    qcthat.emoji = FALSE,
    .local_envir = call
  )
  rlang::inject(
    testthat::expect_snapshot(
      {{ x }}
    ),
    env = call
  )
}
