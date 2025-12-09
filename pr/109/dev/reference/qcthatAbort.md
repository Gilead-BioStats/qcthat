# Generate a classed qcthat error

Generate a classed qcthat error

## Usage

``` r
qcthatAbort(
  strErrorMessage,
  strErrorSubclass,
  envCall = rlang::caller_env(),
  envErrorMessage = rlang::caller_env(),
  cndParent = NULL,
  ...
)
```

## Arguments

- strErrorMessage:

  (`length-1 character`) A message to include in and error report. Can
  include
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html)
  syntax.

- strErrorSubclass:

  (`length-1 character`) A subclass for an error condition.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

- envErrorMessage:

  (`environment`) The environment to pass to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html) to
  resolve variables.

- cndParent:

  (`condition` or `NULL`) Parent condition, if any.

- ...:

  Additional parameters to pass to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).
