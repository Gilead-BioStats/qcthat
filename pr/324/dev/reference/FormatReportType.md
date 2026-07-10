# Prepare the body of one report in set of reports

Prepare the body of one report in set of reports

## Usage

``` r
FormatReportType(
  fnReport,
  strReportType,
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  chrIgnoredLabels = DefaultIgnoreLabels(),
  dfITM = NULL,
  lOtherArgs = list(),
  envCall = rlang::caller_env()
)
```

## Arguments

- fnReport:

  (`function`) The function that generates the report data, such as
  [`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md).

- strReportType:

  (`length-1 character`) The main title of the report, such as
  `"Completed Issues"` or `"PR-Associated Issues"`.

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

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)).

- lOtherArgs:

  (`list`) Additional arguments to pass to `fnReport`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

A string containing the report formatted in GitHub markdown.
