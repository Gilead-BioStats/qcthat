---
name: document
description: Document package functions. Use when asked to document functions.
---

# Document functions

*All* functions should be documented in {roxygen2} `#'` style, including internal/unexported functions.

- Run `devtools::document()` after changing any roxygen2 docs.
- Use sentence case for all headings

## Shared parameters

**Parameters used in more than one function should be documented in `R/aaa-shared.R`** under the `@name shared-params` section. Functions then use `@inheritParams shared-params` to inherit these parameter definitions.

The `aaa-shared.R` file:
- Alphabetizes parameters
- Uses `@name shared-params` to group all parameters under one documentation topic
- Includes `@keywords internal` to mark it as internal
- Ends with `NULL` (required for roxygen2 processing)

## Parameter documentation format

Parameters follow this format:
```r
#' @param paramName (`TYPE`) One sentence description. Can include [cross_references()].
#'   Additional details on continuation lines if needed.
```

### Type notation examples

- "(`character`)" - Character vector
- "(`length-1 character`)" - Single string
- "(`length-1 integer`)" - Single integer  
- "(`length-1 logical`)" - Single boolean
- "(`data.frame`)" - Data frame
- "(`list`)" - List object
- "(`environment`)" - Environment object

## Parameter naming conventions

**Hungarian-style prefixes** indicate parameter type:
- `str*` - Single string (length-1 character): `strTitle`, `strBody`, `strOwner`
- `chr*` - Character vector: `chrLabels`, `chrTests`, `chrMilestones`
- `int*` - Integer: `intIssue`, `intPageMax`, `intLineStart`
- `lgl*` - Logical: `lglUpdate`, `lglWarn`, `lglOverwrite`
- `df*` - Data frame: `dfITM`, `dfRepoIssues`, `dfTestResults`
- `l*` - List: `lTestResults`, `lCommentsRaw`, `lGHEventPayload`
- `env*` - Environment: `envCall`, `envErrorMessage`
- `dttm*` - Datetime/POSIXct: `dttmTimestamp`
- `fct*` - Factor: `fctDisposition`
- `obj*` - Object: `objShape`

## Return value documentation

Use `@returns` (not `@return`) with specific details:

**Simple returns:**
```r
#' @returns An integer representing the number of unique non-NA values.
```

**Structured returns with columns:**
```r
#' @returns A `qcthat_Issues` object, which is a [tibble::tibble()] with
#'   columns:
#'   - `Issue`: Issue number.
#'   - `Title`: Issue title.
#'   - `State`: Issue state (`open` or `closed`).
```

**Invisible returns:**
```r
#' @returns The input `chrChecks`, invisibly.
```
```r
#' @returns `NULL` (invisibly).
```

## Cross-references

Use square brackets for function cross-references:
- External packages: `[tibble::tibble()]`, `[glue::glue()]`
- Internal functions: `[FetchRepoIssues()]`, `[CompileTestResults()]`

These auto-generate hyperlinks in help documentation.

## Examples sections

**For interactive/network-dependent functions:**
```r
#' @examplesIf interactive()
#' 
#'   FetchRepoIssues()
```

**For self-contained examples:**
```r
#' @examples
#' CompileTestResults(test_results_object)
```

The `@examplesIf interactive()` pattern skips examples during `R CMD check`.

## Grouping related documentation

Use `@rdname` to group related functions (especially S3 methods) under one help page:

```r
#' Printing qcthat objects
#' @name printing
NULL

#' @rdname printing
#' @export
print.qcthat_Object <- function(x, ...) { ... }

#' @rdname printing  
#' @export
format.qcthat_Object <- function(...) { ... }
```

## S3 method exports

For S3 methods of functions from other packages:
```r
#' @exportS3Method dplyr::filter
filter.qcthat_IssueTestMatrix <- function(.data, ...) { ... }
```

## Internal functions

Internal (unexporeted) functions use abbreviated documentation:

```r
#' Title in sentence case
#'
#' @inheritParams shared-params
#' @returns Use the rules as described above.
#' @keywords internal
```

- No `@description` paragraph after the title.
- No blank `#'` lines between sections (other than the title and the rest).
- `@keywords internal` instead of `@export`.
- No `@examples` nor `@examplesIf`.
