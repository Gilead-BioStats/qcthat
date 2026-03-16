---
name: document
description: Document package functions. Use when asked to document functions.
---

# Document functions

*All* functions should be documented in {roxygen2} `#'` style, including internal/unexported functions.

- Run `air format .` then `devtools::document()` after changing any roxygen2 docs.
- Use sentence case for all headings.

## Shared parameters

**Parameters used in more than one function should be documented in `R/aaa-shared.R`** under the `@name shared-params` section. Functions then use `@inheritParams shared-params` to inherit these parameter definitions.

The `aaa-shared.R` file:
- Alphabetizes parameters
- Uses `@name shared-params` to group all parameters under one documentation topic
- Includes `@keywords internal` to mark it as internal
- Ends with `NULL` (required for roxygen2 processing)

## Parameter documentation format

```r
#' @param paramName (`TYPE`) One sentence description. Can include [cross_references()].
#'   Additional details on continuation lines if needed.
```

Function-specific `@param` definitions always appear *before* any `@inheritParams` lines.

### Type notation

- "(`character`)" - Character vector
- "(`length-1 character`)" - Single string
- "(`length-1 integer`)" - Single integer
- "(`length-1 logical`)" - Single boolean
- "(`data.frame`)" - Data frame
- "(`list`)" - List object
- "(`environment`)" - Environment object

### Enumerated values

When a parameter takes one of a fixed set of values, document them with a bullet list:

```r
#' @param strState (`length-1 character`) State of issues to fetch. Can be
#'   one of:
#'   * `"open"`: Open issues only.
#'   * `"closed"`: Closed issues only.
#'   * `"all"`: All issues regardless of state.
```

## Exported functions

```r
#' Title in sentence case
#'
#' Description paragraph providing context and details.
#'
#' @param strParam (`TYPE`) Description.
#' @inheritParams shared-params
#'
#' @returns Description of return value.
#' @seealso [RelatedFunction()]
#' @export
#'
#' @examples
#' ExampleFunction()
```

- Blank `#'` lines separate: title/description, description/params, and `@export`/`@examples`.
- `@seealso` (optional) goes between `@returns` and `@export`.
- `@details` can supplement the description when needed.

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

Internal (unexported) functions use abbreviated documentation:

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
