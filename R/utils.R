#' Create a directory
#'
#' @param directory_path
#'
#' @importFrom usethis ui_done ui_path ui_stop
#'
#' @keywords internal
create_directory <- function(directory_path) {

  if (dir.exists(directory_path)) {
    return(invisible(FALSE))
  } else if (file.exists(directory_path)) {
    usethis::ui_stop("{ui_path(directory_path)} exists but is not a directory.")
  }

  dir.create(directory_path, recursive = TRUE)
  usethis::ui_done("Creating {ui_path(directory_path)}")

  return(invisible(TRUE))
}

#' @importFrom usethis proj_sitrep
#' @keywords internal
check_project_status <- function() {

  project_status <- usethis::proj_sitrep()

  return(project_status[[1]] == project_status[[3]])

}
