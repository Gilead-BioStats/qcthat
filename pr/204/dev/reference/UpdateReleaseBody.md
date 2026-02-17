# Update the body of a GitHub release

Update the body of a GitHub release

## Usage

``` r
UpdateReleaseBody(
  strReleaseID,
  strBody,
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- strReleaseID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub release.

- strBody:

  (`length-1 character`) The body of an issue, PR, comment, or release,
  in GitHub markdown.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions to read issues.

## Value

The updated release object as returned by
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html).
