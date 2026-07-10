# Check that line numbers are in valid order

Check that line numbers are in valid order

## Usage

``` r
CheckFileLineOrder(intLineStart, intLineEnd, envCall = rlang::caller_env())
```

## Arguments

- intLineStart:

  (`length-1 integer`) The starting line number.

- intLineEnd:

  (`length-1 integer`) The ending line number.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

Invisibly returns `NULL`. Called for its side effect of validating line
order.
