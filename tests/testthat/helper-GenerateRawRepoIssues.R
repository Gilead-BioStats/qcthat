GenerateRawRepoIssues <- function(
  intIssueCount = 10L,
  lglIncludeMilestones = TRUE,
  lglIncludeTypes = TRUE
) {
  lIssuesRaw <- vector("list", intIssueCount)
  for (i in rev(seq_len(intIssueCount))) {
    lIssuesRaw[[i]] <- list(
      number = i,
      title = paste("Issue number", i),
      body = paste("This is the body of issue number", i),
      labels = if (i %% 2 == 0) list(list(name = "x")) else list(),
      state = if (i %% 3 == 0) "closed" else "open",
      html_url = paste0(
        "https://github.com/Gilead-BioStats/fakerepo/issues/",
        i
      )
    )
    if (i %% 3 == 0) {
      lIssuesRaw[[i]]$state_reason <- "completed"
      lIssuesRaw[[i]]$closed_at <- "2025-10-16 15:53:00"
    }
    if (lglIncludeMilestones && i %% 4 == 0) {
      lIssuesRaw[[i]]$milestone <- list(title = paste("Milestone", i / 4))
    }
    if (lglIncludeTypes && i %% 3 == 0) {
      lIssuesRaw[[i]]$type <- list(name = "Feature")
    }
  }
  lIssuesRaw[[3]]$pull_request <- list("nonempty")
  return(lIssuesRaw)
}
