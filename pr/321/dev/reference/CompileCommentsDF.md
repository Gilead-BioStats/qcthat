# Compile comments data frame

Compile comments data frame

## Usage

``` r
CompileCommentsDF(lCommentsRaw)
```

## Arguments

- lCommentsRaw:

  (`list`) List of raw comment objects as returned by
  [`gh::gh()`](https://gh.r-lib.org/reference/gh.html).

## Value

A `qcthat_Comments` object, which is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Body`: Comment body (the full text of the comment).

- `Url`: URL of the comment on GitHub.

- `CommentGHID`: GitHub ID of the comment.

- `Author`: GitHub username of the comment author.

- `CreatedAt`: `POSIXct` timestamp of when the issue was created.

- `UpdatedAt`: `POSIXct` timestamp of when the issue was last updated.

- `qcthatCommentID`: The `qcthat-comment-id`, which is usually a hash of
  the title of the comment (when present).
