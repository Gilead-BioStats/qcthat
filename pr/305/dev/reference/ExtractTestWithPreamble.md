# Extract test code with file preamble

Extract test code with file preamble

## Usage

``` r
ExtractTestWithPreamble(
  chrFileLines,
  intLineStart,
  intLineEnd,
  intFirstTestLine
)
```

## Arguments

- chrFileLines:

  (`character`) All lines of the test file.

- intLineStart:

  (`length-1 integer`) Start line of the test block.

- intLineEnd:

  (`length-1 integer`) End line of the test block.

- intFirstTestLine:

  (`length-1 integer`) Line number of the first `test_that()` call in
  the file.

## Value

A character vector of the preamble (if any) followed by the test code.
