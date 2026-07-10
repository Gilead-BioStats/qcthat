# Comment on a PR or issue with QC reports

Add or update a comment on a GitHub pull request (or issue) with one or
more QC reports, formatted in GitHub markdown.

## Usage

``` r
CommentAllReports(
  intPRNumber = GuessPRNumber(strOwner = strOwner, strRepo = strRepo, strGHToken =
    strGHToken),
  lglCompleted = TRUE,
  lglMilestone = length(chrMilestones),
  lglPR = TRUE,
  lglUAT = TRUE,
  chrMilestones = GuessMilestones(),
  dfITM = NULL,
  lglUpdate = TRUE,
  strRunID = Sys.getenv("GITHUB_RUN_ID"),
  strJobName = Sys.getenv("GITHUB_JOB"),
  strPkgRoot = ".",
  strOwner = GetGHOwner(strPkgRoot),
  strRepo = GetGHRepo(strPkgRoot),
  strGHToken = gh::gh_token(),
  lglWarn = TRUE,
  chrIgnoredLabels = DefaultIgnoreLabels(),
  envCall = rlang::caller_env()
)
```

## Arguments

- intPRNumber:

  (`length-1 integer`) The number of the pull request to fetch
  information about and/or post results to.

- lglCompleted:

  (`length-1 logical`) Whether to include the
  [`QCCompletedIssues()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCCompletedIssues.md)
  report.

- lglMilestone:

  (`length-1 logical`) Whether to include the
  [`QCMilestones()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCMilestones.md)
  report.

- lglPR:

  (`length-1 logical`) Whether to include the
  [`QCPR()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPR.md)
  report.

- lglUAT:

  (`length-1 logical`) Whether to include the
  [`CommentUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentUAT.md)
  report.

- chrMilestones:

  (`character`) The name(s) of milestone(s) to filter issues by.

- dfITM:

  (`qcthat_IssueTestMatrix`) A `qcthat_IssueTestMatrix` object as
  returned by
  [`AsIssueTestMatrix()`](https://gilead-biostats.github.io/qcthat/dev/reference/AsIssueTestMatrix.md)
  (often via
  [`QCPackage()`](https://gilead-biostats.github.io/qcthat/dev/reference/QCPackage.md)).

- lglUpdate:

  (`length-1 logical`) Whether to update an existing comment or label if
  it already exists (rather than creating a new comment or label).

- strRunID:

  (`length-1 character`) ID (typically numeric but can be very long) of
  a GitHub Actions workflow run.

- strJobName:

  (`length-1 character`) Name of a GitHub Actions workflow job.

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

- lglWarn:

  (`length-1 logical`) Whether to warn when an extra value is included
  in the filter (but the report still returns results). Defaults to
  `TRUE`.

- chrIgnoredLabels:

  (`character`) GitHub labels to ignore, such as `"qcthat-nocov"`.

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

`dfITM`, invisibly.
