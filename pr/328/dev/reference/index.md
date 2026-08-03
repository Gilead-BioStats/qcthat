# Package index

## All functions

- [`Action_qcthat()`](https://gilead-public.github.io/qcthat/dev/reference/Action_qcthat.md)
  : Use a GitHub Action to manage qcthat
- [`AssignIssue()`](https://gilead-public.github.io/qcthat/dev/reference/AssignIssue.md)
  : Assign a GitHub issue to one or more users
- [`AttachReleaseReports()`](https://gilead-public.github.io/qcthat/dev/reference/AttachReleaseReports.md)
  : Attach QC reports to a GitHub release
- [`CommentAllReports()`](https://gilead-public.github.io/qcthat/dev/reference/CommentAllReports.md)
  : Comment on a PR or issue with QC reports
- [`CommentIssue()`](https://gilead-public.github.io/qcthat/dev/reference/CommentIssue.md)
  : Comment on a GitHub Issue
- [`CommentReport()`](https://gilead-public.github.io/qcthat/dev/reference/CommentReport.md)
  : Comment on a PR or issue with a QC report
- [`CommentUAT()`](https://gilead-public.github.io/qcthat/dev/reference/CommentUAT.md)
  **\[experimental\]** : Comment on a PR or issue with a UAT report
- [`CompileIssueTestMatrix()`](https://gilead-public.github.io/qcthat/dev/reference/CompileIssueTestMatrix.md)
  : Create a nested tibble of issues and tests
- [`CompileTestResults()`](https://gilead-public.github.io/qcthat/dev/reference/CompileTestResults.md)
  : Extract information from testthat results
- [`DefaultIgnoreLabels()`](https://gilead-public.github.io/qcthat/dev/reference/DefaultIgnoreLabels.md)
  : Default labels to ignore
- [`DefaultIgnoreLabelsDF()`](https://gilead-public.github.io/qcthat/dev/reference/DefaultIgnoreLabelsDF.md)
  : Default ignored labels as a tibble
- [`ExpectUserAccepts()`](https://gilead-public.github.io/qcthat/dev/reference/ExpectUserAccepts.md)
  **\[experimental\]** : Does a user accept the feature?
- [`ExtractTestsFromFiles()`](https://gilead-public.github.io/qcthat/dev/reference/ExtractTestsFromFiles.md)
  **\[experimental\]** : Extract test information from test files
- [`FetchPRIssueNumbers()`](https://gilead-public.github.io/qcthat/dev/reference/FetchPRIssueNumbers.md)
  : Fetch all issues associated with a GitHub pull request
- [`FetchRefPRNumber()`](https://gilead-public.github.io/qcthat/dev/reference/FetchRefPRNumber.md)
  : Fetch the pull request number for a branch or other git ref
- [`FetchRepoIssueClosers()`](https://gilead-public.github.io/qcthat/dev/reference/FetchRepoIssueClosers.md)
  : Fetch repository issue closers
- [`FetchRepoIssues()`](https://gilead-public.github.io/qcthat/dev/reference/FetchRepoIssues.md)
  : Fetch repository issues
- [`FetchRepoPRs()`](https://gilead-public.github.io/qcthat/dev/reference/FetchRepoPRs.md)
  : Fetch repository pull requests
- [`GetGHOwner()`](https://gilead-public.github.io/qcthat/dev/reference/GetGHOwner.md)
  : Find the owner of the target repository
- [`GetGHRepo()`](https://gilead-public.github.io/qcthat/dev/reference/GetGHRepo.md)
  : Find the name of the target repository
- [`GetSessionInfo()`](https://gilead-public.github.io/qcthat/dev/reference/GetSessionInfo.md)
  : Get session info from available reporting functions
- [`GuessIssueNumber()`](https://gilead-public.github.io/qcthat/dev/reference/GuessIssueNumber.md)
  : Guess the relevant issue number from the GitHub event
- [`GuessMilestones()`](https://gilead-public.github.io/qcthat/dev/reference/GuessMilestones.md)
  : Guess relevant milestone names from the GitHub event
- [`GuessPRNumber()`](https://gilead-public.github.io/qcthat/dev/reference/GuessPRNumber.md)
  : Guess the most relevant pull request number
- [`GuessReleaseID()`](https://gilead-public.github.io/qcthat/dev/reference/GuessReleaseID.md)
  : Guess the relevant release id from the GitHub event
- [`IsCheckingUAT()`](https://gilead-public.github.io/qcthat/dev/reference/IsCheckingUAT.md)
  : Detect whether the user is specifically checking UAT issues
- [`LoadGHEventPayload()`](https://gilead-public.github.io/qcthat/dev/reference/LoadGHEventPayload.md)
  : Load the GitHub event payload
- [`LoadUATIssues()`](https://gilead-public.github.io/qcthat/dev/reference/LoadUATIssues.md)
  : Load UAT issues from disk
- [`MapIssueClosersToCommits()`](https://gilead-public.github.io/qcthat/dev/reference/MapIssueClosersToCommits.md)
  : Add Commits list column to dfIssueClosers
- [`MapLongIssueCommits()`](https://gilead-public.github.io/qcthat/dev/reference/MapLongIssueCommits.md)
  **\[experimental\]** : Map issues to commits in long format
- [`MapTestFilesToPotentialIssues()`](https://gilead-public.github.io/qcthat/dev/reference/MapTestFilesToPotentialIssues.md)
  **\[experimental\]** : Map test files to potential issues
- [`PrepareTestIssueContext()`](https://gilead-public.github.io/qcthat/dev/reference/PrepareTestIssueContext.md)
  **\[experimental\]** : Prepare test issue context for analysis
- [`QCCompletedIssues()`](https://gilead-public.github.io/qcthat/dev/reference/QCCompletedIssues.md)
  : Generate a QC report of completed issues
- [`QCIssues()`](https://gilead-public.github.io/qcthat/dev/reference/QCIssues.md)
  : Generate a QC report of specific issues
- [`QCMergeGH()`](https://gilead-public.github.io/qcthat/dev/reference/QCMergeGH.md)
  : Generate a QC report of issues associated with a GitHub merge
- [`QCMergeLocal()`](https://gilead-public.github.io/qcthat/dev/reference/QCMergeLocal.md)
  : Generate a QC report of issues probably related to changes between
  local git refs
- [`QCMilestones()`](https://gilead-public.github.io/qcthat/dev/reference/QCMilestones.md)
  : Generate a QC report of a specific milestone or milestones
- [`QCPR()`](https://gilead-public.github.io/qcthat/dev/reference/QCPR.md)
  : Generate a QC report of issues associated with a GitHub pull request
- [`QCPackage()`](https://gilead-public.github.io/qcthat/dev/reference/QCPackage.md)
  : Generate a QC report for a package
- [`ReadJSONAsIssueTestMatrix()`](https://gilead-public.github.io/qcthat/dev/reference/ReadJSONAsIssueTestMatrix.md)
  : Read a JSON file as an IssueTestMatrix
- [`SaveAsJSON()`](https://gilead-public.github.io/qcthat/dev/reference/SaveAsJSON.md)
  : Save an object as JSON
- [`SaveUATIssues()`](https://gilead-public.github.io/qcthat/dev/reference/SaveUATIssues.md)
  : Save UAT issues to disk
- [`SetupGHLabels()`](https://gilead-public.github.io/qcthat/dev/reference/SetupGHLabels.md)
  : Setup qcthat labels in a GitHub repository
- [`Skill_TagTestsWithIssues()`](https://gilead-public.github.io/qcthat/dev/reference/Skill_TagTestsWithIssues.md)
  **\[experimental\]** : Use an AI skill to tag tests with issues
- [`TriggerUAT()`](https://gilead-public.github.io/qcthat/dev/reference/TriggerUAT.md)
  **\[experimental\]** : Trigger the UAT cycle for closed issues
- [`UpdateIssue()`](https://gilead-public.github.io/qcthat/dev/reference/UpdateIssue.md)
  : Update a GitHub issue
- [`print(`*`<qcthat_Object>`*`)`](https://gilead-public.github.io/qcthat/dev/reference/printing.md)
  [`format(`*`<qcthat_Object>`*`)`](https://gilead-public.github.io/qcthat/dev/reference/printing.md)
  : Printing qcthat objects
- [`use_qcthat()`](https://gilead-public.github.io/qcthat/dev/reference/use_qcthat.md)
  : Set up qcthat for a package
