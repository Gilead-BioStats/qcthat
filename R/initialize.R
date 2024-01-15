#' Initialize `{qcthat}` testing framework.
#'
#' @return Testing framework described in `{qcthat}` README.
#'
#' @examples
#' \dontrun{
#' initialize()
#' }
#'
#' @export
initialize <- function() {

  init_specs()

  init_test_cases()

}
