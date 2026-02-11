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

Start by extracting all tests and processing them file-by-file:

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
- **`PotentialIssueDetails`**: A tibble with columns `Issue`, `Title`, and `Body` for each potentially related issue (list column). These potential issues are identified by matching commits that modified the test with commits that closed issues.
- **`TestCode`**: The actual test code (list column of character vectors)

## Step 2: Match Tests to Issues

For each test, compare the test description (`Test` column) against the issue details in `PotentialIssueDetails`:

### Primary Matching Strategy

1. **Read the test description** - This often contains clear keywords about what's being tested
2. **Compare with issue titles** - Look for semantic overlap between test names and issue titles
3. **Check issue bodies** - Review the full issue description for context
4. **Consider already-tagged issues** - The `Issues` column shows what's already tagged; avoid duplicates

### When Test Description Is Insufficient

If the relationship isn't clear from just the test description and issue titles/bodies, consult the **`TestCode`** column to understand what the test actually does. This helps when:
- Test descriptions are generic or unclear
- Multiple issues seem equally relevant
- The test covers multiple scenarios

### Common Matching Patterns

- **Feature tests**: Match to feature request issues describing the behavior being tested
- **Bug tests**: Match to bug report issues that the test prevents regressing
- **Edge case tests**: Often match to specific bug reports about that scenario

### Example Analysis

```r
# Look at a single test's context
target_test_row <- 1
target_test <- dplyr::slice(dfTestIssueContext, target_test_row)

# View potential issues
target_test$PotentialIssueDetails[[1]]

# If needed, examine the test code
cat(target_test$TestCode[[1]], sep = "\n")
```

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
