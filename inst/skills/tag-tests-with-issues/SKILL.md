---
name: tag-tests-with-issues
description: Identify likely GitHub issues connected to test cases. Use when asked to tag tests with issues or get started with qcthat.
---

# Tag tests with issues

Add issue references (e.g., `(#123)`) to test descriptions to connect tests to features/bugs they address.

## Step 1: Load context

Pre-compute issue-commit mappings once with `MapLongIssueCommits()` and pass to `MapTestFilesToPotentialIssues()`. Do not skip this—its output is required for `PrepareTestIssueContext()`, your sole source of context for remaining steps.

```r
library(qcthat)
dfFileTests <- ExtractTestsFromFiles()
dfIssueCommitsLong <- MapLongIssueCommits()
# If timeout, split: split(dfFileTests, dfFileTests$File) and process per file
dfPotentialIssues <- MapTestFilesToPotentialIssues(dfFileTests, dfIssueCommitsLong = dfIssueCommitsLong)
dfTestIssueContext <- PrepareTestIssueContext(dfPotentialIssues)
```

`PrepareTestIssueContext()` returns tibble with `Test` (chr), `File` (chr), `LineStart`/`LineEnd` (int), `Issues` (list of int vecs, already-tagged), `PotentialIssueDetails` (list of tibbles with `Issue`, `Title`, `Body`), `TestCode` (list of chr vecs).

## Step 2: Match tests to issues

For each test, compare code/description against `PotentialIssueDetails`. Do not use `git blame`, `gh`, or other tools. Matches must come only from `PotentialIssueDetails` for that test. Most tests match one issue; some zero; few >1.

### Decision process

For every test with non-empty `PotentialIssueDetails`:

1. **Read `TestCode`** (ground truth over descriptions). Extract: primary function called, `expect_*()` assertions, edge cases.
2. **Read ENTIRE `Body`** of each potential issue (titles are often misleading). Note whether it names the tested function, describes the specific behavior, and its purpose (feature, bugfix, or unrelated).
3. **Function name match**: Issue body mentions the function AND is about implementing/fixing/extending it → strong match. Passing mentions don't count.
4. **If no function match, check behavioral match** (higher bar): body must describe the *specific behavior* tested, not just the general feature area. Same feature area alone is insufficient. E.g., test checking `ValidateCardNumber()` rejects expired cards matches "add validation for expired card numbers" but NOT "Payment processing" discussing order workflows.
5. **Decide**: Tag if strong function match (3) or specific behavioral match (4). Skip if unrelated. **When uncertain, lean toward skipping** (untagged tests are findable later; wrong tags must be removed in review).
6. **Check `Issues` column** for existing tags. Don't re-add.

### Common errors

Do NOT match on: keyword overlap in title only; feature-area proximity without behavioral match; body contradicting title (trust body); incidental file changes from infrastructure/cleanup; description when `TestCode` shows different behavior.

### Special cases

- **`intIssue` in `ExpectUserAccepts()` calls**: Tag with that issue number unless obviously test data (1, 12, 123).
- **Already tagged**: If `Issues` looks correct, skip. When adding, preserve existing tags, sort ascending.
- **Similar issues**: Read each body fully, pick most specific to tested behavior. Reject infrastructure/broad feature issues. Multiple tags only if genuinely both pass steps 3–4.

### Example

```r
test <- dfTestIssueContext[5, ]
test$Test        # '"ProcessPayment handles declined cards"'
test$TestCode    # calls ProcessPayment(), expects error-payment_declined
test$PotentialIssueDetails[[1]]
#   Issue  Title                               Body
#   42     "Payment system overhaul"           "Refactor payment module architecture..."
#   87     "Payment processing error handling" "Implement ProcessPayment() to handle declined cards..."
#   104    "Add logging to payment module"     "Add debug logging throughout payment..."
# 42: refactoring, not implementing → NO
# 87: explicitly mentions ProcessPayment() + declined cards → YES
# 104: logging, unrelated → NO
# Decision: Tag #87
```

## Step 3: Edit test files

Format: `test_that("does something (#123)", { ... })` or `(#123, #456)` for multiple.

Rules: Only edit the parenthetical issue tags in `test_that()` descriptions. Preserve existing tags; sort ascending. Use `File`/`LineStart`/`LineEnd` to locate. Batch edits per file; preserve style.

```r
IssuesToTag <- 87L  # include existing tags if any
test$IssueTags <- glue::glue("#{IssuesToTag}") |> glue::glue_collapse(sep = ", ")
readLines(test$File) |>
  stringr::str_replace(stringr::fixed(test$Test), glue::glue_data(test, "{Test} ({IssueTags})")) |>
  writeLines(test$File)
```

## Log reasoning

Keep a running log in `pkgdown/assets/test_tag_reasons.qmd` (renders to HTML). Table per file: "Test", "Issue" (absolute GitHub link), "Reason" (1–2 sentences). Update as you work, not at the end.

## Validation

After tagging: run `devtools::test(reporter = "check")` (only descriptions should change, snapshots may update), re-run `ExtractTestsFromFiles()` to confirm `Issues` contains tagged numbers, render `test_tag_reasons.qmd`.
