# Paste together standardized pieces of a condition class

Paste together standardized pieces of a condition class

## Usage

``` r
CompileConditionClasses(
  strConditionSubclass,
  strConditionClass = c("error", "warning", "message")
)
```

## Arguments

- strConditionSubclass:

  (`length-1 character`) A subclass for a condition.

- strConditionClass:

  (`length-1 character`) One of "error", "warning", or "message".

## Value

A character vector of condition classes.
