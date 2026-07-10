# Business process

Here we describe an example business process for implementing quality
control using [qcthat](https://gilead-biostats.github.io/qcthat/). This
process is intended to ensure that program development, testing, review,
and acceptance are conducted in a structured manner.

## Roles

- 👑 or TL: Team Lead
- 🧑‍💻 or PD: Program Developer
- 🧪 or QCP: Quality Control Programmer
- 💼 or USR: User or Requester
- 🤖 or AUTO: Automated System

## Overview

1.  **👑💼🧑‍💻 File Issues:** Team Lead, Program Developer, and/or User
    documents requirements using Github Issues.
2.  **🧑‍💻 Write Code:** Program Developer updates code and associated
    documentation in R package.
3.  **🧑‍💻🧪 Write Tests:** Program Developer or Quality Control
    Programmer writes needed tests and connects them to the issue by
    including `(#{issue_number})` in the test description.
4.  **👑🤖 Release Package:** Upon a GitHub release, all tests are
    automatically run and a summary report linking issues with
    associated tests is attached to the release.

Additional configuration details for each core step are described in the
following sections.

## Intake 🧑‍💻💼

- 🧑‍💻💼: (optional) PD receives request from USR.
- 🧑‍💻💼: PD or USR creates a GitHub issue for each business requirement.
- 🧑‍💻: PD creates and links separate issues or sub-issues to document
  technical requirements and implementation details for each business
  requirement.

## Code Development 🧑‍💻👑🧪💼

- 🧑‍💻: PD develops or modifies the package using the user requirements.
- 👑🧑‍💻🧪💼: All stakeholders (PD, TL, QCP and USR) add comments and
  reactions on the issue to finalize scope as needed.
- 🧑‍💻: PD provides clear description of changes with every commit
  comment. If developer chooses to provide a message addressing a
  specific change, the commit comment should be a descriptive, concise,
  single-line summary of the change. If more context is needed, PD
  should add a comment to an issue in GitHub.

## Testing 🧑‍💻🧪

- 🧑‍💻🧪: Where applicable, QCP or PD defines an automated test for every
  applicable user requirement to demonstrate that the information
  displayed by the report/application is fit for purpose and meets the
  stated requirement. Testing is performed by using
  [testthat](https://testthat.r-lib.org). Tests are linked to the
  corresponding business requirements with “(#{issue_number})” in the
  description.
- 🧪: QCP confirms that all requirements addressed by the change are
  associated with appropriate tests. If no tests are appropriate, the
  reasoning is logged in the GitHub issue, and the issue is labeled with
  “qcthat-nocov”.
- 🤖: Automated testing is executed via GitHub Actions.

## Code Review 🧑‍💻🧪

- 🧑‍💻: Upon completion of code development and testing, the PD initiates
  a Pull Request (PR). All relevant issues and tests are linked to the
  PR.
- 🧪: QCP determines appropriate level of review, verifies the code
  and/or output against the user requirements, and documents the method
  and results.
- 🧪: For user-acceptance tests (see
  [`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExpectUserAccepts.md)),
  QCP documents approval of the feature by closing each UAT issue, or
  comments with required changes.
- 🧑‍💻🧪: All questions and necessary code adjustments are addressed in
  the process of code review.

## QC and Acceptance 👑🧪

- 👑: Once the PD has addressed all required feedback, the TL conducts a
  final review of the code changes and documentation. TL verifies that
  all tests have passed, all requirements are tested, the website is
  successfully deployed (if applicable), and the release pull request
  (PR) correctly targets the primary branch.
- 🧪🤖: For user-acceptance tests (see
  [`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExpectUserAccepts.md)),
  QCP or an automated system re-opens UAT issues for requirements that
  require user approval.
- 💼: For user-acceptance tests (see
  [`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/dev/reference/ExpectUserAccepts.md)),
  USR documents approval of the feature by closing each UAT issue, or
  comments with required changes.
- 👑🧪🤖: When the qualification of the program is completed, QCP
  confirms and documents the result and acceptance (aided by automated
  reports). Final acceptance of the package is documented by the TL or
  QCP through formal approval of the Pull Request (PR) within GitHub.
  Once the request is approved, the finalized code is merged into the
  main code base and ready for release.

## Release 🧑‍💻🧪🤖

- Upon acceptance, the PD or QCP creates a formal release in accordance
  with established version control conventions. This serves as
  documentation and as an equivalent of program deployment into a
  production environment.
  [qcthat](https://gilead-biostats.github.io/qcthat/) attaches reports
  to the release as specified in the action created with
  [`Action_qcthat()`](https://gilead-biostats.github.io/qcthat/dev/reference/Action_qcthat.md).
