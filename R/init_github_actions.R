#' Initialize GitHub Actions YAML File for Reporting
#'
#' @return `.github/workflows` folder at root directory; `qualification_report.yaml` file.
#'
#' @export
init_github_actions <- function() {

  if (check_project_status()) {
    usethis::use_github_action(
      url = "https://raw.githubusercontent.com/Gilead-BioStats/gsm/dev/.github/workflows/qualification-report.yaml",
      save_as = "qualification_report.yaml"
      )

    github_actions_path <- paste0(usethis::proj_path(), "/.github/workflows")

    invisible(
      file.copy(
        from = system.file("template", "qualification_report.yaml", package = "qcthat"),
        to = paste0(github_actions_path, "/qualification_report.yaml"),
        overwrite = TRUE
      )
    )

  }

}
