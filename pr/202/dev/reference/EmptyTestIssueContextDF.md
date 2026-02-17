# Create empty test issue context data frame

Create empty test issue context data frame

## Usage

``` r
EmptyTestIssueContextDF()
```

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Test`: Test description (character).

- `File`: Test file name (character).

- `LineStart`: Starting line number of test.

- `LineEnd`: Ending line number of test.

- `Issues`: List column containing integer vectors of issue numbers
  already tagged in the test description.

- `PotentialIssueDetails`: List column of tibbles with enriched issue
  details.

- `TestCode`: List column of character vectors containing test code.
