#' Initialize testing directory structure and template file.
#'
#' @return `tests/testqualification/qualification` directory; `test_qual_T1_1.R` file.
#'
#' @importFrom rlang check_installed
#'
#' @export
init_test_cases <- function() {

  usethis:::check_is_project()

  rlang::check_installed("testthat")

  directory_path <- paste0(getwd(), "/tests/testqualification/qualification")

  create_directory(directory_path = directory_path)

  copy_test_case_template(directory_path = directory_path)

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
