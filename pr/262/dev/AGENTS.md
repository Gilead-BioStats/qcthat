# AGENTS.md

## Skills

Skills in @.github/skills should be loaded when the user triggers them.

| Triggers              | Path                                           |
|-----------------------|------------------------------------------------|
| tag tests with issues | @.github/skills/tag-tests-with-issues/SKILL.md |
| document functions    | @.github/skills/document/SKILL.md              |
| search / rewrite code | @.github/skills/search-code/SKILL.md           |

## Testing

- Before starting any coding task, run the relevant tests and check
  coverage so you know the baseline state.
- Always run `air format .` before running tests, after every R file
  edit.
- Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`.
- Use `devtools::test(reporter = "check")` to run all tests
- Use `devtools::test(filter = "name", reporter = "check")` to run tests
  for `R/{name}.R`
- All testing functions automatically load code; you don’t need to.
- All new code should have an accompanying test.
- If there are existing tests, place new tests next to similar existing
  tests.

### Test coverage

The goal is 100% file-level test coverage across all R source files.
After editing a file, ensure that it still has 100% test coverage.

To check coverage for a single file:

``` r
covr_res <- devtools:::test_coverage_active_file("R/FileName.R")
which(purrr::map_int(covr_res, "value") == 0)
```

The following files are intentionally excluded from coverage
requirements (no associated tests):

- `R/aaa-shared.R`
- `R/qcthat-package.R`

## Documentation

After adding or changes functions, create or update their documentation.
See @.github/skills/document/SKILL.md for details on documentation for
this project.
