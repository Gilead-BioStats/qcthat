GenerateRawRepoPRs <- function(intPRCount = 5L) {
  lPRsRaw <- vector("list", intPRCount)
  for (i in rev(seq_len(intPRCount))) {
    lPRsRaw[[i]] <- list(
      number = i,
      title = paste("PR number", i),
      body = paste("This is the body of PR number", i),
      state = if (i %% 3 == 0) "closed" else "open",
      created_at = "2025-10-15 12:34:00",
      closed_at = if (i %% 3 == 0) "2025-10-16 15:53:00",
      merged_at = if (i %% 3 == 0) "2025-10-16 15:53:00",
      html_url = paste0(
        "https://github.com/Gilead-BioStats/fakerepo/PRs/",
        i
      ),
      head = list(ref = paste0("headref", i)),
      base = list(ref = paste0("baseref", i)),
      merge_commit_sha = if (i %% 3 == 0) paste0("mergesha", i),
      draft = (i %% 5 == 0)
    )
  }
  return(lPRsRaw)
}
