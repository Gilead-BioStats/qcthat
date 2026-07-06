# Set up qcthat for a package

Set up qcthat labels and GitHub Action workflow for a package
repository. This function combines
[`SetupGHLabels()`](https://gilead-biostats.github.io/qcthat/dev/reference/SetupGHLabels.md)
and
[`Action_qcthat()`](https://gilead-biostats.github.io/qcthat/dev/reference/Action_qcthat.md)
to create the necessary GitHub labels and install the GitHub Action
workflow for managing qcthat Quality Control. We recommend reviewing the
generated action to determine whether you would like to turn any
features off.

## Usage

``` r
use_qcthat(
  dfLabels = DefaultIgnoreLabelsDF(),
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
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

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

`TRUE` (invisibly).

## Examples

``` r
if (FALSE) { # interactive()

  use_qcthat()
}
```
