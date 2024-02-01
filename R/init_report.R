#' Initialize Qualification Report Template
#'
#' @importFrom here here
#' @keywords internal
init_report <- function(package_name = read.dcf("DESCRIPTION")[[1]]) {

  if (is.null(package_name)) {

    usethis::ui_oops("Package name cannot be read from DESCRIPTION file. Make sure you have a DESCRIPTION file with a 'Package:' field.")

  } else {

    # add basic rmd to `~/vignettes/articles`
    usethis::use_article("Qualification", "Qualification")

    # modify the report to add the current package name
    report_template <- readLines(system.file("template", "qualification_template.Rmd", package = "qcthat"))
    report_template <- gsub("XXXXXXXXXX", package_name, report_template)
    writeLines(report_template, here::here("vignettes", "articles", "Qualification.Rmd"))

  }



}
