test_that("qcthatPath constructs paths (#73)", {
  expect_equal(
    qcthatPath(c("dir1", "dir2", "file"), "txt"),
    system.file("dir1", "dir2", "file.txt", package = "qcthat")
  )
})

test_that("InstallFile copies files as expected (#73)", {
  strPkgRoot <- withr::local_tempdir("PkgRoot")
  strqcthatRoot <- withr::local_tempdir("qcthatRoot")
  strSourceFile <- withr::local_tempfile(
    lines = c("This is a source file."),
    tmpdir = strqcthatRoot,
    fileext = ".txt"
  )
  strSourceFileBase <- fs::path_file(strSourceFile) |>
    fs::path_ext_remove()
  strTargetPath <- fs::path(strPkgRoot, "targetdir", "targetfile.txt")
  local_mocked_bindings(
    GetPkgRoot = function(strPkgRoot, ...) strPkgRoot,
    qcthatPath = function(chrPath, strExtension) {
      rlang::inject(fs::path(strqcthatRoot, !!!chrPath, ext = strExtension))
    }
  )
  expect_snapshot(
    {
      strReturnedPath <- withVisible(InstallFile(
        strSourceFileBase,
        c("targetdir", "targetfile"),
        strExtension = "txt",
        strPkgRoot = strPkgRoot
      ))
    },
    transform = function(x) {
      sub("Edit at .+$", "Edit at <target_path>", x)
    }
  )
  expect_false(strReturnedPath$visible)
  expect_equal(strReturnedPath$value, strTargetPath)
})
