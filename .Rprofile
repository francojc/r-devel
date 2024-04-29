.First <- function() {
  cat("You are now working from:", getwd(), "\n")
}

# Aliases for common setups

.required_pkgs <- function() {
  # Install pak if not already installed
  if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak"); pak::pak_install_extra();

  # Check if the renv package is installed
  if (!requireNamespace("renv", quietly = TRUE)) pak::pak("renv")
}

# Package development
.pkg_dev <- function() {
  # Install required packages
  .required_pkgs()

  if (!requireNamespace("devtools", quietly = TRUE)) pak::pak("devtools")
  if (!requireNamespace("usethis", quietly = TRUE)) pak::pak("usethis")
  if (!requireNamespace("pkgdown", quietly = TRUE)) pak::pak("pkgdown")
  if (!requireNamespace("testthat", quietly = TRUE)) pak::pak("testthat")

  # Load the packages
  library(devtools)
  library(usethis)
  library(pkgdown)
  library(testthat)
}

# Generate a list of dependencies for a project
.create_dependencies <- function(additional_pkgs = NULL) {

  # Install required packages
  .required_pkgs()

  vscode_pkgs <- c("languageserver", "httpgd", "rmarkdown", "xml2", "downlit")

  pkgs <- c(renv::dependencies(quiet = TRUE)$Package, vscode_pkgs, additional_pkgs)

  pkg_list <- pak::pkg_list()
  pkg_list <- pkg_list[pkg_list$package %in% pkgs, c("package", "version", "remoteusername")]

  # If `remoteusername` is NA, then it is a CRAN package
  pkg_list$packages <- ifelse(is.na(pkg_list$remoteusername),
    paste0(pkg_list$package, "@", pkg_list$version), paste0(pkg_list$remoteusername, "/", pkg_list$package))

  writeLines(pkg_list$packages, con = "dependencies.txt")
}

.setup_renv <- function() {
  # Load the renv package (bare)
  renv::init(bare = TRUE)
}

# Restore the project dependencies
.restore_dependencies <- function() {
  # Install required packages
  .required_pkgs()

  # Read the dependencies from the file
  pkgs <- readLines("dependencies.txt")

  # Install the dependencies
  pak::pkg_install(pkgs)

  # Snapshot the dependencies
  renv::snapshot()
}

.Last <- function() {
  cat("\n¡Adiós!\n") # Say bye!
}
