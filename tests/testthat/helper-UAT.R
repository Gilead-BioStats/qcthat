# Don't impact the envQcthat$UATIssues environment df used for tracking UAT.
local_dfUATIssues <- function(env = rlang::caller_env()) {
  dfUATIssues_Start <- envQcthat$UATIssues
  withr::defer(
    {
      envQcthat$UATIssues <- dfUATIssues_Start
    },
    envir = env
  )
  envQcthat$UATIssues <- dfUATIssues_Empty
}
