# Trigger the UAT cycle for closed issues

**\[experimental\]**

Identify pull requests that mention a closed issue, and potentially
re-trigger the UAT cycle. If all issues referenced in the UAT comment of
a linked PR are closed (and it is not already running the QCPR
workflow), rerun the QCPR workflow (`qcthat.yaml`) if available.

## Usage

``` r
TriggerUAT(
  intClosedIssue = GuessIssueNumber(),
  strOwner = GetGHOwner(),
  strRepo = GetGHRepo(),
  strGHToken = gh::gh_token()
)
```

## Arguments

- intClosedIssue:

  (`length-1 integer`) A closed UAT issue number.

- strOwner:

  (`length-1 character`) GitHub username or organization name.

- strRepo:

  (`length-1 character`) GitHub repository name.

- strGHToken:

  (`length-1 character`) GitHub token with permissions appropriate to
  the action being performed.

## Value

A `data.frame` of PRs that referenced the issue (invisibly). This
function is called for its side effects.

## See also

Other UAT functions:
[`CommentUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/CommentUAT.md),
[`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExpectUserAccepts.md),
[`IsCheckingUAT()`](https://gilead-biostats.github.io/qcthat/dev/reference/IsCheckingUAT.md)
