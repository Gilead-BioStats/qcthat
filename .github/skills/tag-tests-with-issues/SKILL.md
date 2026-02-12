---
name: tag-tests-with-issues
description: Identify likely GitHub issues connected to test cases. Use when asked to tag tests with issues or get started with qcthat.
---

# Tag Tests with Issues

Connect test cases to their related GitHub issues by adding issue references (e.g., `(#123)`) to test descriptions. This creates bidirectional traceability between tests and the features or bugs they address.

## Overview

The workflow involves:
1. Extracting tests from all test files with `ExtractTestsFromFiles()`
2. Splitting tests by file for processing
3. Mapping each test file to potential issues with `MapTestFilesToPotentialIssues()`
4. Preparing full context with `PrepareTestIssueContext()`
5. Analyzing test descriptions and potential issues to find matches
6. Updating test files to add issue tags to test descriptions

## Step 1: Load Test and Issue Context

Start by extracting all tests and processing them file-by-file. `MapTestFilesToPotentialIssues()` can be very slow, so be sure to only ever process one file at a time, and even then be prepared to wait. Do not attempt to speed up the process by avoiding this function. Its output is required for `PrepareTestIssueContext()`, and the output of `PrepareTestIssueContext()` serves as your source of truth for the remaining steps. Here we show the workflow for the first file.

```r
library(qcthat)

# Extract all tests from test files
dfFileTests <- ExtractTestsFromFiles()

# Split into one data frame per test file
lFileTestsSplit <- dplyr::group_split(dfFileTests, File)

# Process a single file (demonstrating with the first file)
# In practice, you should process all files unless told otherwise
dfPotentialIssues <- MapTestFilesToPotentialIssues(lFileTestsSplit[[1]])
dfTestIssueContext <- PrepareTestIssueContext(dfPotentialIssues)
```

**About `lFileTestsSplit`**: This is a list containing one data frame per test file. Each element contains all the tests from a single file. The example above shows processing the first file (`lFileTestsSplit[[1]]`), but you should typically iterate through all files in the list.

`PrepareTestIssueContext()` returns a data frame with these columns:
- **`Test`**: The test description (character)
- **`File`**: Test file name (character) 
- **`LineStart`** / **`LineEnd`**: Line numbers in the test file
- **`Issues`**: Issues already tagged in the test description (list column of integer vectors)
- **`PotentialIssueDetails`**: A tibble with columns `Issue`, `Title`, and `Body` for each potentially related issue (list column). These potential issues are identified by matching commits that modified the test with commits that closed issues. The `Body` column contains critical information for accurate matching.
- **`TestCode`**: The actual test code (list column of character vectors)

## Step 2: Match Tests to Issues

For each test, compare the test description (`Test` column) against the issue details in `PotentialIssueDetails`. You will not need to use `git blame` or other such tools to identify likely connections. Your matches for each test should only include zero or more of the potential issues in `PotentialIssueDetails`. Many tests will match exactly one issue. Some will match zero. A few may match multiple issues.

### Matching Philosophy: Precision Over Recall

**The primary goal is to avoid incorrect tags.** An incorrect tag is worse than a missing tag because:
- Wrong tags create false traceability (misleading)
- Missing tags can be added later when more information is available

When uncertain, **skip the test** rather than guess.

### Primary Matching Strategy

Read issue bodies thoroughly, not just titles. Titles are often vague, abbreviated, or misleading. The issue body contains the specific technical details needed to make accurate matches.

For each test:

1. **Extract the exact function name(s) from `TestCode`**
   - This is your most reliable matching key
   - Look at what functions are actually called in the test, not just what the description says
   
2. **For each potential issue, read the ENTIRE Body carefully**
   - Skim-reading causes false matches
   - Look for the specific function name being tested
   - Look for the specific behavior or scenario being tested
   - Note the PURPOSE of the issue: Is it about creating this feature? Fixing a bug in it? Refactoring something unrelated?
   
3. **Require strong evidence before matching**
   - The issue must be ABOUT the functionality being tested, not just tangentially related
   - Keyword overlap alone is NOT sufficient
   - The issue should describe creating, implementing, or fixing the specific thing the test verifies

4. **Consider already-tagged issues** - The `Issues` column shows what's already tagged; avoid duplicates

### Critical: Avoid Common Matching Errors

**Do NOT match based on superficial keyword overlap.** These are the most common failure patterns:

- ❌ Test mentions "X" → Matching any issue with "X" in the title (e.g., test about "comments" matched to issue titled "Update comment handling" that's actually about something else)
- ❌ Test is about function `Foo()` → Matching an issue about the broader feature area that doesn't mention `Foo()` specifically
- ❌ Issue title sounds relevant but Body describes unrelated work
- ❌ Issue is about infrastructure, refactoring, or cleanup that happened to touch the file but isn't about the test's functionality
- ❌ Matching based on the test DESCRIPTION when the TestCode shows it's actually testing something different

**Only match when you have STRONG evidence:**

- ✅ The issue body explicitly names the function being tested (e.g., "Implement `ProcessOrder()` to handle...")
- ✅ The issue body describes the EXACT behavior or scenario the test verifies
- ✅ The issue describes fixing a bug that manifests in exactly the way the test checks
- ✅ The test is clearly a verification that the issue's requirements are met

**When in doubt, do NOT match.** It is better to leave a test untagged than to tag it incorrectly.

### Matching Guidelines

**Be precise and conservative.** The goal is accuracy ahead of coverage. Many tests will not have a clear match, and that's okay.

**Confidence threshold:** Only tag a test if you are **confident** the issue is directly about the functionality being tested. "Probably related" or "might be connected" is not enough.

**How to distinguish between similar-sounding issues:**

When multiple issues seem related:
1. Read each issue body COMPLETELY (not just the first paragraph)
2. Look for the one that specifically describes implementing or fixing the exact functionality being tested
3. Reject issues that are about:
   - Infrastructure, refactoring, or code cleanup (unless the test specifically checks something about the infrastructure)
   - A broader feature area without mentioning this specific function
   - Something that sounds similar but describes different behavior
4. If none of the issues clearly match, **do not tag the test**

**Examples illustrating the confidence threshold:**

- Test: "SaveUserPreferences stores settings correctly" + Issue body: "Implement `SaveUserPreferences()` function to persist user settings to the database" → **Match** (function name + behavior both match)
- Test: "SaveUserPreferences stores settings correctly" + Issue body: "Add user preferences feature" (no function names mentioned) → **Probably skip** (too vague to be confident)
- Test: "ValidateEmail handles invalid addresses" + Issue about "Password reset flow" → **No match** (different functionality entirely)
- Test: "ProcessOrder calculates tax correctly" + Issue body: "Refactor order processing module" → **No match** (refactoring issue, not about tax calculation)

### Decision Process for Each Test

For every test with non-empty `PotentialIssueDetails`, follow this process IN ORDER:

1. **Extract the exact function name(s) from TestCode** - This is your primary search key. Look at the actual function calls, not just the description.

2. **Search each issue Body for that exact function name**
   - If an issue body contains the function name AND describes implementing/fixing it → **Strong match candidate**
   - If no issue body contains the function name → proceed to step 3, but be extra cautious

3. **If no function name match, check for exact behavioral match**
   - The issue must describe the EXACT behavior or scenario the test verifies
   - Vague descriptions of the feature area are NOT sufficient
   - If the match feels like a stretch, **skip the test**

4. **Apply the "wrong tag test"**
   - Before tagging, ask: "If this tag is wrong, would it be misleading?"
   - If the answer is yes and you're not highly confident, **skip the test**

5. **Final decision**
   - **Tag** only if you found strong evidence in steps 2-3
   - **Skip** if you're relying on keyword overlap, vague similarity, or intuition

### Always Consult TestCode

**Never rely solely on test descriptions.** Test descriptions can be vague, outdated, or misleading. Always read the `TestCode` column to understand what the test ACTUALLY does.

**Extract these signals from TestCode:**
- Primary function being called (e.g., `MyCoolFunction(...)`) — this is your most important signal
- What the `expect_*` calls verify — this tells you the exact behavior being tested
- Edge cases being tested (empty input, error conditions, etc.)
- Any setup code that reveals context

**The function name from TestCode should drive your matching**, not the prose description.

### Common Matching Patterns

- **Function implementation tests**: Match to the issue that describes creating that function (look for function name in Body)
- **Edge case tests**: Match to bug reports describing that specific edge case
- **Behavior verification tests**: Match to feature requests describing the expected behavior

### Red Flags: When NOT to Match

Skip tagging a test if:
- The only connection is keyword overlap in titles
- The issue is about refactoring, cleanup, or infrastructure
- The issue body doesn't mention the specific function or behavior being tested
- You're "pretty sure" but not confident
- Multiple issues seem equally plausible (unless you can clearly pick the best one)
- The test seems to be about basic functionality that predates the potential issues

### Complete Example: Matching a Test to Issues

```r
# After running PrepareTestIssueContext for a file:
test <- dfTestIssueContext[5, ]

# Step 1: Read the test description AND extract function name from code
test$Test
# "ProcessPayment handles declined cards"
test$TestCode[[1]]
# Shows: ProcessPayment(...) being called with test data

# Step 2: Check potential issues - READ THE BODIES
test$PotentialIssueDetails[[1]]
#   Issue Title                                Body
#   42    "Payment system overhaul"            "Refactor payment module architecture..."
#   87    "Payment processing error handling"  "Implement ProcessPayment() function to handle
#                                               declined cards, expired cards, and..."
#   104   "Add logging to payment module"      "Add debug logging throughout payment..."

# Step 3: Analyze matches BY READING BODIES
# - Issue 42: Body is about refactoring, not implementing ProcessPayment - NO MATCH
# - Issue 87: Body explicitly mentions "ProcessPayment()" and "declined cards" - STRONG MATCH
# - Issue 104: Body is about logging, not payment handling - NO MATCH

# Decision: Tag with #87 (the Body specifically describes this functionality)

# Step 4: Make the edit
# Change: test_that("ProcessPayment handles declined cards", {
# To:     test_that("ProcessPayment handles declined cards (#87)", {
```

The key insight: Issue 87's **Body** mentioned the exact function and behavior, not just keyword overlap in the title.

## Step 3: Tag Tests with Issues

Once you've identified which issue(s) match a test, update the test file:

### Format

Add issue references in parentheses at the end of the test description:
- Single issue: `test_that("does something (#123)", { ... })`
- Multiple issues: `test_that("does something (#123, #456)", { ... })`

### Editing Guidelines

1. **Preserve existing tags**: If `Issues` column shows existing tags, keep them unless they're incorrect
2. **Add new tags**: Append new issue numbers to the description
3. **Sort issue numbers**: Keep issue numbers in ascending order
4. **Use consistent format**: Always use `(#123)` format with parentheses and hash
5. **Preserve existing test content**: Do not edit anything other than the parenthetical issues tags

### Making the Edits

Use the `File`, `LineStart`, and `LineEnd` columns to locate the exact test in the file, then update the `test_that()` description string.

For programmatic editing:
```r
# Read the test file
lines <- readLines(file.path("tests/testthat", test_file))

# Update the specific line(s) containing the test_that() call
# The description is typically on LineStart

# Write back
writeLines(lines, file.path("tests/testthat", test_file))
```

## Expected Outcomes

You should successfully tag:
- Tests where the issue Body explicitly names the function being tested
- Tests where the issue Body describes the exact behavior the test verifies
- **All tests** with explicit `intIssue` references in `ExpectUserAccepts()` calls

You should **skip** (not tag):
- Tests where you only have keyword overlap or vague similarity
- Tests where the potential issues are about refactoring or infrastructure
- Tests where none of the potential issues clearly describe the tested functionality
- Tests where you're uncertain

**Accuracy over coverage**: A wrong tag actively harms traceability. A missing tag is neutral — it can be added later. Target **zero incorrect tags** even if that means leaving many tests untagged.

## Tips

1. **Batch edits by file**: Group edits to the same file together to minimize file I/O
2. **Preserve formatting**: Maintain existing code style and indentation when editing
3. **Handle edge cases**: 
   - Tests already fully tagged (skip)
   - Tests with no good matches (skip)
   - Multi-line test descriptions (preserve line breaks)

## Validation

After tagging:
- Ensure tests still run: `devtools::test()`
- Re-run the extraction and context preparation workflow to verify tags were parsed correctly
  - Confirm that the `Issues` column now contains the tagged issue numbers
