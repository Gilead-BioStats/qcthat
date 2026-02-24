source_dir <- "slides"
dest_dir <- "pkgdown/assets"
to_copy <- c(
  fs::dir_ls(source_dir, glob = "*.qmd"),
  fs::dir_ls(source_dir, glob = "*.css")
)
fs::file_copy(to_copy, dest_dir, overwrite = TRUE)
fs::dir_copy(
  fs::path(source_dir, "slide_images"),
  fs::path(dest_dir, "slide_images"),
  overwrite = TRUE
)

slide_qmds <- fs::dir_ls(dest_dir, glob = "*.qmd")
for (qmd_file in slide_qmds) {
  file_base <- fs::path_ext_remove(fs::path_file(qmd_file))
  output_file <- paste0("slides-", file_base, ".html")
  quarto::quarto_render(qmd_file, output_file = output_file)
}
fs::file_delete(slide_qmds)
