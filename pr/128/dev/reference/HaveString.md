# Detect strings in lists of characters

Detect strings in lists of characters

## Usage

``` r
HaveString(lCharacters, strTarget)
```

## Arguments

- lCharacters:

  (`list` of `character`) A list of character vectors.

- strTarget:

  (`length-1 character`) The target string to search for.

## Value

A logical vector indicating whether `strTarget` is present in each
element of `lCharacters`.
