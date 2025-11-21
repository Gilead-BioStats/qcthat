# Setup qcthat labels in a GitHub repository

Create the qcthat labels in a GitHub repository if those labels do not
already exist.

## Usage

``` r
SetupGHLabels(
  dfLabels = DefaultIgnoreLabelsDF(),
  strOwner = gh::gh_tree_remote()[["username"]],
  strRepo = gh::gh_tree_remote()[["repo"]],
  strGHToken = gh::gh_token()
)
```

## Arguments

- dfLabels:

  (`data.frame`) A data frame with columns `Label`, `Description`, and
  `Color`, specifying the labels to create. By default, this is the data
  frame returned by
  [`DefaultIgnoreLabelsDF()`](https://gilead-biostats.github.io/qcthat/dev/reference/DefaultIgnoreLabelsDF.md).
  Descriptions of labels created via this function are prefixed with
  `"{qcthat}: "` to make it easier to search for them in your list of
  labels.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

`NULL` (invisibly).
