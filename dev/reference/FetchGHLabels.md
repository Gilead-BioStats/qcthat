# Fetch GitHub labels as a data frame

Fetch GitHub labels as a data frame

## Usage

``` r
FetchGHLabels(
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns:

- `Label`: Label name.

- `Description`: Label description.

- `Color`: Label color as a hex code (e.g., `"#444444"`).
