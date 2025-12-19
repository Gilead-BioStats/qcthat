GenerateRawIssueComments <- function(intCommentCount = 5L) {
  lCommentsRaw <- purrr::map(
    seq_len(intCommentCount),
    function(i) {
      lComment <- list(
        id = i,
        body = paste("This is the body of comment number", i),
        user = list(
          login = paste0("user", i),
          id = 1000 + i
        ),
        created_at = "2025-10-15 12:34:00",
        updated_at = "2025-10-16 15:53:00",
        html_url = paste0("https://fake.api.com/", i)
      )
      if (i %% 2 == 0) {
        lComment$body <- paste(
          lComment$body,
          "with qcthat-comment-id:",
          rlang::hash(i)
        )
      }
      lComment
    }
  )
  return(lCommentsRaw)
}
