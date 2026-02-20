# AGENTS.md

## Skills

Skills in @.github/skills should be loaded when the user triggers them.
If you understand how to use them without these special instructions,
use your core skill capabilities.

| Trigger               | Path                                           |
|-----------------------|------------------------------------------------|
| tag tests with issues | @.github/skills/tag-tests-with-issues/SKILL.md |
| document functions    | @.github/skills/document/SKILL.md              |

## Test Coverage

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
