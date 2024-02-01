#' Initialize `{qcthat}` testing framework.
#'
#' @param package_name Name of package.
#'
#' @return Testing framework described in `{qcthat}` README.
#'
#' @examples
#' \dontrun{
#' initialize()
#' }
#'
#' @export
initialize <- function(package_name = read.dcf("DESCRIPTION")[[1]]) {

  init_specs()

  init_test_cases()

  init_report(package_name = package_name)

  init_github_actions()
}
