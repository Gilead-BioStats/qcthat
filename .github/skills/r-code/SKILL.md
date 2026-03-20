---
name: r-code
description: Guide for writing R code in qcthat. Use when writing new functions, designing APIs, or reviewing/modifying existing R code.
---

# R code in qcthat

This skill covers how to design and write R functions in this package —
including naming conventions, signatures, API conventions, error handling, and
common pitfalls. For documenting functions, use the `document` skill. For
tests, use the `tdd-workflow` skill.

## Naming conventions

**Functions** use PascalCase (UpperCamelCase):

```r
FetchRepoIssues()       # exported
CompileIssueTestMatrix() # exported
EnframeIssues()          # internal helper, same convention
```

**Parameters** use Hungarian-style prefixes to indicate type:

| Prefix | Type | Examples |
|--------|------|---------|
| `str*` | Single string (`length-1 character`) | `strTitle`, `strOwner`, `strRepo` |
| `chr*` | Character vector | `chrLabels`, `chrTests`, `chrMilestones` |
| `int*` | Integer | `intIssue`, `intPageMax`, `intLineStart` |
| `lgl*` | Logical | `lglUpdate`, `lglWarn`, `lglOverwrite` |
| `df*` | Data frame | `dfITM`, `dfRepoIssues`, `dfTestResults` |
| `l*` | List | `lTestResults`, `lCommentsRaw`, `lGHEventPayload` |
| `env*` | Environment | `envCall`, `envErrorMessage` |
| `dttm*` | Datetime/POSIXct | `dttmTimestamp` |
| `fct*` | Factor | `fctDisposition` |
| `obj*` | Object (other) | `objShape` |

```r
FetchRepoIssues <- function(
  strOwner = GetGHOwner(),   # length-1 character
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token(),
  strState = c("all", "open", "closed"),
  lglUpdate = FALSE,         # length-1 logical
  intPageMax = 100L,         # length-1 integer
  envCall = rlang::caller_env()
) { ... }
```

**Files** are named after the exported function they define:
`R/FetchRepoIssues.R` for `FetchRepoIssues()`.

## General API design patterns

**Enum-like arguments** — declare choices as the default vector; resolve with
`rlang::arg_match()` at the top of the function:

```r
MyFunction <- function(x, mode = c("fast", "safe")) {
  mode <- rlang::arg_match(mode)
  # mode is now guaranteed to be "fast" or "safe"
}
```

**`NULL` as "not provided"** — use `NULL` as the default for optional
arguments where there is no sensible scalar fallback; check with `is.null()`:

```r
MyFunction <- function(x, strNamesTo = NULL) {
  if (!is.null(strNamesTo)) { ... }
}
```

**S3 object construction** — build as a named list or tibble, set class
explicitly with a dedicated constructor helper:

```r
# Constructor assigns class
AsMyObject <- function(x) {
  class(x) <- c("qcthat_MyObject", class(x))
  x
}
```

**`envCall` propagation in internal validators** — helpers that validate
arguments and may throw errors should accept and forward `envCall`:

```r
CheckSomething <- function(x, envCall = rlang::caller_env()) {
  if (bad(x)) qcthatAbort("...", "bad_input", envCall = envCall)
}

MyExportedFn <- function(x, envCall = rlang::caller_env()) {
  CheckSomething(x, envCall)
}
```

**Return tibbles, not plain data frames.** Typed subclasses (e.g.,
`qcthat_Issues`) are tibbles with an additional class set by a constructor
like `AsIssuesDF()`.

## Internal vs. exported functions

Export a function when:
- Users will call it directly
- Other packages may want to extend it
- It is a stable, intentional part of the API

Keep a function internal when:
- It is an implementation detail that may change
- It is only used within the package
- Exporting it would clutter the user-facing API

Internal helpers use PascalCase like exported ones, but with `@keywords internal` and no `@export`.

## Error handling

Use `qcthatAbort()` (defined in `R/aaa-conditions.R`) rather than calling
`cli::cli_abort()` directly. This ensures consistent error class formatting:

```r
qcthatAbort(
  "Input {.arg strOwner} cannot be empty.",
  "bad_input",
  envCall = envCall
)
```

`qcthatAbort()` generates error classes of the form:
`qcthat-error-{subclass}`, `qcthat-error`, `qcthat-condition`.

Always pass `envCall = envCall` (or `envCall = rlang::caller_env()`) so errors
point to the user's call frame, not an internal helper.

## Common package mistakes

```r
# Never use library() inside package code
library(dplyr)          # Wrong
dplyr::filter(...)      # Right
# or `@importFrom dplyr filter` if used extensively

# Never modify global state without restoring it
options(my_option = TRUE)                    # Wrong
withr::local_options(list(my_option = TRUE)) # Right (in tests; withr is Suggested)

# Use system.file() for package data, not hardcoded paths
read.csv("/home/user/data.csv")                        # Wrong
system.file("extdata", "data.csv", package = "qcthat") # Right
```

## Dependencies

### Use existing imports first

Packages already in `Imports` in `DESCRIPTION` should be preferred over base
R equivalents: `purrr::map()` over `lapply()`, `rlang::is_*()` predicates
over `is.*()`, `vctrs::vec_*()` over base length/NA checks.

### When to add a new dependency

Add a dependency when it provides significant functionality that would be
complex or brittle to reimplement. Stick with base R or existing imports when
the solution is straightforward.

**Adding a new dependency requires explicit discussion with the developer.**
