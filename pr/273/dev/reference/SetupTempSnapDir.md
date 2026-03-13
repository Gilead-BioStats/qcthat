# Create a temp snapshot directory with a copy of the relevant snapshot file

Create a temp snapshot directory with a copy of the relevant snapshot
file

## Usage

``` r
SetupTempSnapDir(strTestFile, strSnapDir)
```

## Arguments

- strTestFile:

  (`length-1 character`) Original test file path.

- strSnapDir:

  (`length-1 character`) Path to the real `_snaps` directory.

## Value

Path to the temp snapshot directory.
