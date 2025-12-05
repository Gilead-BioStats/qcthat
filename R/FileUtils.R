#' Find the root of the package repo
#'
#' @inheritParams shared-params
#' @returns The path to the root of the package.
#' @keywords internal
GetPkgRoot <- function(strPkgRoot, envCall = rlang::caller_env()) {
  # Tested manually.
  #
  # nocov start
  tryCatch(
    pkgload::pkg_path(strPkgRoot),
    pkgload_no_desc = function(cnd) {
      qcthatAbort(
        c(
          "{.arg strPkgRoot} must be a path within an R package.",
          i = "No package DESCRIPTION file could be found at {.path {fs::path_abs(strPkgRoot)}}."
        ),
        envCall = envCall,
        strErrorSubclass = "not_package"
      )
    }
  )
  # nocov end
}

#' Find a path within qcthat
#'
#' Exists primarily to make it easier to mock this for testing.
#'
#' @param chrPath (`character`) Components of a path
#' @inheritParams shared-params
#' @returns The full path to the file within the `qcthat` package.
#' @keywords internal
qcthatPath <- function(chrPath, strExtension) {
  strPath <- rlang::inject(fs::path(!!!chrPath, ext = strExtension))
  system.file(strPath, package = "qcthat")
}

#' Install a file from qcthat into a package repo
#'
#' @inheritParams shared-params
#' @returns The path to the created file (invisibly).
#' @keywords internal
InstallFile <- function(
  chrSourcePath,
  chrTargetPath,
  strExtension,
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
) {
  rlang::check_installed("fs", "to manipulate package files.")
  strPkgRoot <- GetPkgRoot(strPkgRoot, envCall = envCall)
  strTargetPath <- rlang::inject(
    fs::path(strPkgRoot, !!!chrTargetPath)
  )
  strTargetPath <- fs::path_ext_set(strTargetPath, strExtension)
  fs::dir_create(fs::path_dir(strTargetPath))
  strSourcePath <- qcthatPath(chrSourcePath, strExtension)
  strSourcePath <- fs::path_ext_set(strSourcePath, strExtension)
  strCreatedPath <- fs::file_copy(
    strSourcePath,
    strTargetPath,
    overwrite = lglOverwrite
  )
  cli::cli_inform("File installed. Edit at {.path {strCreatedPath}}.")
  return(invisible(strCreatedPath))
}
