# Add blames to expanded dfFileTests

Add blames to expanded dfFileTests

## Usage

``` r
JoinLineCommits(dfFileTestsExpanded, dfBlames)
```

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with the same structure as `dfFileTests` plus a `Commits` list column
containing character vectors of unique commit SHAs that touched each
test, in the order they first appear.
