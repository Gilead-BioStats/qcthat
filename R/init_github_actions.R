#' Initialize GitHub Actions YAML File for Reporting
#'
#' @return `.github/workflows` folder at root directory; `qualification_report.yaml` file.
#'
#' @export
init_github_actions <- function() {

  if (check_project_status()) {

    usethis::use_github_action(
      url = "https://raw.githubusercontent.com/Gilead-BioStats/qcthat/updates/inst/template/qualification_report.yaml?token=GHSAT0AAAAAAB73423PXSOE5F44XAMADPAAZN3X6DQ"
      )
  }


}
