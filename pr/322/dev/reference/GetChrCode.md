# Helper to translate tree characters to codes by name

R CMD check doesn't like these characters appearing "raw", and they're
hard to read as U codes, so encode them in one place.

## Usage

``` r
GetChrCode(strCharacterDescription)
```

## Arguments

- strCharacterDescription:

  (`length-1 character`) The special character to choose.

## Value

A length-1 character vector representing the chosen tree character.
