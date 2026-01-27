# Load the GitHub event payload

Read the JSON file located at `GITHUB_EVENT_PATH` and confirm that it
resembles a GitHub event payload.

## Usage

``` r
LoadGHEventPayload(strGHEventPath = Sys.getenv("GITHUB_EVENT_PATH"))

LoadGHEventPayload(strGHEventPath = Sys.getenv("GITHUB_EVENT_PATH"))
```

## Arguments

- strGHEventPath:

  (`length-1 character`) Path to the GitHub event payload JSON file.
  Defaults to the `GITHUB_EVENT_PATH` environment variable.

## Value

A list containing the parsed JSON payload, or `NULL` if `strGHEventPath`
is empty.

A list containing the parsed JSON payload, or `NULL` if `strGHEventPath`
is empty or does not point to a GitHub event payload.
