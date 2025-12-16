# Create a GitHub label

Create a GitHub label

## Usage

``` r
CreateGHLabel(
  strLabel,
  strLabelDescription = "{qcthat}: A new label",
  strLabelColor = "#444444",
  lglVerbose = getOption("qcthat-verbose", FALSE),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strLabel:

  (`length-1 character`) The name of the label to create.

- strLabelDescription:

  (`length-1 character`) The description for the label.

- strLabelColor:

  (`length-1 character`) The hex color code for the label (e.g.,
  `"#444444"`).

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The raw label object as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html) (invisibly).
