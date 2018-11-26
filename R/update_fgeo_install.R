#' Update the key components (then run `check_built_packages()`).
#'
#' @return Invisible `NULL`.
#' @export
#'
#' @examples
#' \dontrun{
#' update_fgeo_install()
#' out <- check_built_packages()
#' cat(out$value, sep = "\n\n")
#' }
update_fgeo_install <- function() {
  source_file("fgeo_packages")
  source_file("cran_packages")
  update_fgeo_source()
  source_file("scheduled_packages")
}

#' Build fgeo source-packages from github into a local directory.
#'
#' @param pkgs Character vector: The name of packages to update.
#' @param src Character vector: Path to directory where to save output.
#'
#' @return Source packages (.tar.gz files).
#' @export
#'
#' @examples
#' if (requireNamespace("fgeo")) {
#'   # Defaults
#'   pkgs <- fgeo::fgeo_pkgs()
#'   src <- fgeo.install:::path_source()
#' }
#'
#' \dontrun{
#' update_fgeo_source(pkgs, src)
#' }
update_fgeo_source <- function(pkgs = fgeo::fgeo_pkgs(),
                               src = install_src()) {
  urls <- glue("forestgeo/{pkgs}")

  if (dir_exists(src)) dir_delete(src)

  dir_create(src)
  build_github(urls, src)
}

install_src <- function() "../fgeo.install/inst/extdata/source"

#' Update vector to schedule package installation in correct order.
#'
#' @param file Path to a file in data-raw/.
#' @param dir Path to the directory where __fgeo.install__ lives.
#'
#' @return Character vector.
#' @export
#'
#' @examples
#' \dontrun{
#' source_file("scheduled_packages")
#' source_file("fgeo_packages")
#' }
source_file <- function(file, dir = "../fgeo.install") {
  withr::with_dir(
    dir, {
    message("Working on ", getwd())
    source(paste0("data-raw/", file, ".R"))
  })
}
