# Set up the renv-pak environment

# Generate a list of dependencies for a project
.create_dependencies <- function(additional_pkgs = NULL) {

  # Install pak if not already installed
  if (!requireNamespace("pak", quietly = TRUE)) {
    install.packages("pak");
    pak::pak_install_extra();
  }

  # Check if the renv package is installed
  if (!requireNamespace("renv", quietly = TRUE)) {
    pak::pak("renv")
  }

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
  # Read the dependencies from the file
  pkgs <- readLines("dependencies.txt")

  # Install pak if not already installed
  if (!requireNamespace("pak", quietly = TRUE)) {
    install.packages("pak")
    pak::pak_install_extra()
  }

  # Check if the renv package is installed
  if (!requireNamespace("renv", quietly = TRUE)) {
    pak::pak("renv")
  }

  # Install the dependencies
  pak::pkg_install(pkgs)

  # Snapshot the dependencies
  renv::snapshot()
}
