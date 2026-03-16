---
name: tdd-workflow
description: Test-driven development workflow for qcthat. Use when writing any R code (writing new features, fixing bugs, refactoring, or reviewing tests).
---

# TDD workflow for qcthat

## Core principle

Write a failing test first, then implement the minimal code to make it pass,
then refactor. Never write implementation code without a failing test driving it.

## File naming

Tests for `R/{FunctionName}.R` go in `tests/testthat/test-{FunctionName}.R`.
Place new tests next to similar existing ones.

## Running tests

```r
# Full suite
devtools::test(reporter = "check")

# Single file
devtools::test(filter = "FunctionName", reporter = "check")
```

Testing functions load code automatically. You do not need to call `library()` or `devtools::load_all()` separately.

## Coverage

Goal: **100%** for every edited file. After editing `R/FunctionName.R`, verify:

```r
covr_res <- devtools:::test_coverage_active_file("R/FunctionName.R")
which(purrr::map_int(covr_res, "value") == 0)
```

Files excluded from the coverage requirement:
- `R/qcthat-package.R`
- `R/aaa-shared.R`

## Test types

### Unit tests

Test individual functions in isolation:

```r
test_that("FetchRepoIssues() returns a qcthat_Issues tibble (#2)", {
  result <- FetchRepoIssues()
  expect_s3_class(result, "qcthat_Issues")
})
```

### Snapshot tests

For complex outputs that are hard to specify with equality assertions:

```r
test_that("print method is stable (#123)", {
  expect_snapshot(print(CompileTestResults(test_results_object)))
})

# For errors, wrap expect_error() inside expect_snapshot() so both the error
# class and the message text are captured in the snapshot:
test_that("errors on invalid input (#456)", {
  expect_snapshot({
    (expect_error(
      FetchRepoIssues(strOwner = 123),
      class = "qcthat-error"
    ))
  })
})
```

When snapshots change intentionally:

```r
testthat::snapshot_review("test_name")
testthat::snapshot_accept("test_name")
```

Snapshots are stored in `tests/testthat/_snaps/`.

## Test design principles

- **Self-sufficient:** each test contains its own setup, execution, and
  assertion. Tests must be runnable in isolation.
- **Duplication over factoring:** repeat setup code rather than extracting it.
  Clarity beats DRY in tests.
- **One concept per test:** a failing test should tell you exactly what broke.
- **Issue reference in description:** the `desc` of every new `test_that()` call
  should end with a parenthetical issue reference:
  ```r
  test_that("FetchRepoIssues() returns correct columns (#1)", { ... })
  test_that("errors on empty input (#noissue)", { ... })
  ```

## testthat Edition 3 — deprecated patterns

```r
# Deprecated → Modern
context("Data validation")        # Remove — filename serves this purpose
expect_equivalent(x, y)          # expect_equal(x, y, ignore_attr = TRUE)
with_mock(...)                    # local_mocked_bindings(...)
expect_is(x, "data.frame")       # expect_s3_class(x, "data.frame")
```

## Essential expectations

### Equality & identity

```r
expect_equal(x, y)                        # with numeric tolerance
expect_equal(x, y, tolerance = 0.001)
expect_equal(x, y, ignore_attr = TRUE)
expect_identical(x, y)                    # exact match
```

### Conditions

```r
expect_error(code)
expect_error(code, "pattern")
expect_error(code, class = "qcthat-error")
expect_error(code, class = "qcthat-error-bad_input")
expect_warning(code)
expect_no_warning(code)
expect_message(code)
expect_no_message(code)
```

### Collections

```r
expect_setequal(x, y)           # same elements, any order
expect_in(element, set)
expect_named(x, c("a", "b"))
```

### Type & structure

```r
expect_type(x, "double")
expect_s3_class(x, "qcthat_Issues")
expect_length(x, 10)
```

### Logical

```r
expect_true(x)
expect_false(x)
expect_null(x)
```

## `withr` patterns for temporary state

```r
withr::local_options(list(qcthat.option = TRUE))
withr::local_envvar(MY_VAR = "value")
withr::local_tempfile(lines = c("a", "b"))
```

## Fixtures

Store static test data in `tests/testthat/fixtures/` and access via:

```r
test_path("fixtures", "sample.rds")
```

## Mocking

```r
local_mocked_bindings(
  ExternalFn = function(...) "mocked_result"
)
result <- MyFunctionThatCallsExternalFn()
```

## Common mistakes

- **Do not modify tests to make them pass.** Fix the implementation.
- **Do not write tests that depend on other tests' state.** Each test must
  be independently runnable.
