# Save an object as JSON

Save an object as formatted JSON. This is a generic function with a
method for `qcthat_IssueTestMatrix` objects that preserves attributes
and column order.

## Usage

``` r
SaveAsJSON(x, strJSONPath)

# Default S3 method
SaveAsJSON(x, strJSONPath)

# S3 method for class 'qcthat_IssueTestMatrix'
SaveAsJSON(x, strJSONPath)
```

## Arguments

- x:

  (`any`) An R object to save as JSON.

- strJSONPath:

  (`length-1 character`) File path to save or read JSON.

## Value

The input object `x`, invisibly.
