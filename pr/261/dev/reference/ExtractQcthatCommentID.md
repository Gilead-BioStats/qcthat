# Extract the qcthat-comment-id from a comment body

Extract the qcthat-comment-id from a comment body

## Usage

``` r
ExtractQcthatCommentID(strBody)
```

## Arguments

- strBody:

  (`length-1 character`) The body of an issue, PR, comment, or release,
  in GitHub markdown.

## Value

A character vector with the extracted `qcthat-comment-id`, or `NA`.
