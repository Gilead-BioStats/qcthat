# AGENTS.md

## Skills

Skills in @.github/skills should be loaded when the user triggers them. If you understand how to use them without these special instructions, use your core skill capabilities.

| Trigger               | Path                                           |
------------------------|------------------------------------------------|
| tag tests with issues | @.github/skills/tag-tests-with-issues/SKILL.md |

## Function Documentation

*All* functions should be documented in {roxygen2} `#'` style, including internal/unexported functions.

### Shared Parameters

**Parameters used in more than one function should be documented in `R/aaa-shared.R`** under the `@name shared-params` section. Functions then use `@inheritParams shared-params` to inherit these parameter definitions.

The `aaa-shared.R` file:
- Alphabetizes parameters
- Uses `@name shared-params` to group all parameters under one documentation topic
- Includes `@keywords internal` to mark it as internal
- Ends with `NULL` (required for roxygen2 processing)

### Parameter Documentation Format

Parameters follow this format:
```r
#' @param paramName (`TYPE`) One sentence description. Can include [cross_references()].
#'   Additional details on continuation lines if needed.
```

#### Type notation examples

- "(`character`)" - Character vector
- "(`length-1 character`)" - Single string
- "(`length-1 integer`)" - Single integer  
- "(`length-1 logical`)" - Single boolean
- "(`data.frame`)" - Data frame
- "(`list`)" - List object
- "(`environment`)" - Environment object

### Parameter Naming Conventions

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

### Function Visibility

**Exported functions** (public API):
```r
#' @export
```

**Internal functions** (not exported):
```r
#' @keywords internal
```

These are **mutually exclusive** - use one or the other, never both.

### Return Value Documentation

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

### Cross-References

Use square brackets for function cross-references:
- External packages: `[tibble::tibble()]`, `[glue::glue()]`
- Internal functions: `[FetchRepoIssues()]`, `[CompileTestResults()]`

These auto-generate hyperlinks in help documentation.

### Examples

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

### Grouping Related Documentation

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

### S3 Method Exports

For S3 methods of functions from other packages:
```r
#' @exportS3Method dplyr::filter
filter.qcthat_IssueTestMatrix <- function(.data, ...) { ... }
```
