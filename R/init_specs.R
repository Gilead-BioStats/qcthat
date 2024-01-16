#' Initialize Specifications Directory and Template File
#'
#' @return `qualification` folder in `inst`; `qualification_specs.csv` template file in `inst/qualification`
#'
#' @examples
#' \dontrun{
#' init_specs()
#' }
#'
#' @importFrom dplyr tibble
#' @importFrom usethis ui_done ui_path ui_stop
#' @importFrom utils write.csv
#'
#' @export
init_specs <- function() {
  usethis:::check_is_project()

  directory_path <- paste0(getwd(), "/inst/qualification")

  create_directory(directory_path = directory_path)

  create_specs_template(directory_path = directory_path)

}


create_specs_template <- function(directory_path) {

  spec_template <- dplyr::tibble(
    Spec = "1",
    "Test ID" = "1",
    "Tests" = "T1_1",
    "Function Name" = NA_character_,
    "Description" = "This is the description for Spec 1 Test 1...",
    "Risk" = NA_character_,
    "Impact" = NA_character_
  )

  if (dir.exists(directory_path)) {

    specifications_path <- paste0(directory_path, "/qualification_specs.csv")

    utils::write.csv(
      x = spec_template,
      file = specifications_path,
      row.names = FALSE
    )
    usethis::ui_done("Creating {ui_path(specifications_path)}")

  } else if (file.exists(directory_path)) {
    usethis::ui_stop("{ui_path(directory_path)} exists but is not a directory.")
  }


}
