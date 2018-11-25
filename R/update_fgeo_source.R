#' Update the key components (then run `check_built_packages()`).
#'
#' @return Invisible `NULL`.
#' @export
#'
#' @examples
#' \dontrun{
#' update_fgeo_install()
#' check_built_packages()
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
#' # Defaults
#' pkgs <- fgeo::fgeo()
#' src <- fgeo.install::path_source()
#' \dontrun{
#' update_fgeo_source(pkgs, src)
#' }
update_fgeo_source <- function(pkgs = fgeo::fgeo(),
                               src = fgeo.install::path_source()) {
  urls <- glue("forestgeo/{pkgs}")

  if (dir_exists(src)) dir_delete(src)

  dir_create(src)
  build_github(urls, src)
}

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
