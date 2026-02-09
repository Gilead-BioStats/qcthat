# Parse a single test_that call

Parse a single test_that call

## Usage

``` r
ParseTest(chrTestLines, intTestStart)
```

## Arguments

- chrTestLines:

  (`character`) Vector of lines from a test file.

- intTestStart:

  (`length-1 integer`) Line number where test_that starts.

## Value

A list with `desc`, `start`, and `end`, or NULL if parsing fails.
