# Extract label names from label objects

Extract label names from label objects

## Usage

``` r
ExtractName(lColumn, strName)
```

## Arguments

- lColumn:

  (`list`) A list column of objects.

- strName:

  (`length-1 character`) Name of the field to extract from each object.

## Value

A character vector of the target field from each object, or `NA` if the
field is missing from a given element of the list.
