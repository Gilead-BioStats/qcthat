#' Initialize testing directory structure and template file.
#'
#' @return `tests/testqualification/qualification` directory; `test_qual_T1_1.R` file.
#'
#' @import usethis
#' @importFrom utils getFromNamespace
#'
#' @export
init_test_cases <- function() {

  if (check_project_status()) {

    directory_path <- paste0(
      usethis::proj_sitrep()$working_directory,
      "/tests/testqualification/qualification"
      )

    create_directory(directory_path = directory_path)

    copy_test_case_template(directory_path = directory_path)


    use_dep <- utils::getFromNamespace("use_dependency", "usethis")

    use_dep("testthat", "Suggests")

  } else {
    usethis::ui_oops("You are either not in an R project or your working directory has been changed.")
  }



}



copy_test_case_template <- function(directory_path) {

  if (dir.exists(directory_path)) {

    file.copy(
      from = system.file("template", "test_qual_T1_1.R", package = "qcthat"),
      to = directory_path
    )

    first_test_path <- paste0(directory_path, "/test_qual_T1_1.R")

    usethis::ui_done("Creating {ui_path(first_test_path)}")

  } else if (file.exists(directory_path)) {
    usethis::ui_stop("{ui_path(directory_path)} exists but is not a directory.")
  }

}
