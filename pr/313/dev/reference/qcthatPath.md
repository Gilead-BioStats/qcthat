# Find a path within qcthat

Exists primarily to make it easier to mock this for testing.

## Usage

``` r
qcthatPath(chrPath, strExtension)
```

## Arguments

- chrPath:

  (`character`) Components of a path

- strExtension:

  (`length-1 character`) The file extension to use for the target file.
  If the target path already includes an extension, it will be replaced
  with this value. If the value is already correct, this won't have any
  effect.

## Value

The full path to the file within the `qcthat` package.
