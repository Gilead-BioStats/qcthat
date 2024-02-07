#' Initialize Qualification Report Template
#'
#' @importFrom here here
#' @keywords internal
init_report <- function(package_name = read.dcf("DESCRIPTION")[[1]]) {

  if (is.null(package_name)) {

    usethis::ui_oops("Package name cannot be read from DESCRIPTION file. Make sure you have a DESCRIPTION file with a 'Package:' field.")

  } else {

    # add basic rmd to `~/vignettes/articles`
    dir.create("vignettes", showWarnings = FALSE)

    # modify the report to add the current package name
    report_template <- readLines(system.file("template", "qualification_template.Rmd", package = "qcthat"))
    report_template <- gsub("XXXXXXXXXX", package_name, report_template)
    writeLines(report_template, "vignettes/Qualification.Rmd")

    use_dep <- utils::getFromNamespace("use_dependency", "usethis")
    use_dep("devtools", "Suggests")
    use_dep("rlang", "Suggests")

    usethis::ui_done("Added `devtools` to Suggests in DESCRIPTION file.")
    usethis::ui_done("Added `rlang` to Suggests in DESCRIPTION file.")

  }



}
