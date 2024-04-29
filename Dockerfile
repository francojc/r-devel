# Dockerfile
# R development image
# Author: Jerid Francom
# Includes: R, Python3, Radian, Pandoc, Quarto, TinyTeX, Zsh, and Antidote

# Start from the r-ver:4.3.3 image
FROM rocker/r-ver:4.3.3

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends
RUN apt-get install -y \
    sudo \
    git \
    zsh \
    bat \
    duf \
    tldr \
    tree \
    python3 \
    python3-pip \
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libicu-dev \
    libpng-dev \
    libxml2-dev \
    libcurl4-openssl-dev

# Install Radian
RUN pip3 install radian

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up environmental variables
ENV S6_VERSION=v2.1.0.2
ENV PANDOC_VERSION=3.1.13
ENV QUARTO_VERSION=1.4.553

# Set the default CRAN repository
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install Pandoc, and Quarto
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh

# Add user 'vscode' with sudo permissions
RUN useradd -ms /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo

# Ensure 'vscode' has sudo without password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change the default shell to zsh for 'vscode' user
RUN chsh -s /bin/zsh vscode

# Create directory '/home/vscode/' and set it as the working directory
RUN mkdir -p /home/vscode/
WORKDIR /home/vscode/

# Copy .zshrc file into ~/ directory
COPY .zshrc /home/vscode/

# Copy .pk10.zsh file into ~/ directory
COPY .p10k.zsh /home/vscode/

# Copy .zsh_plugins.txt file into ~/ directory
COPY .zsh_plugins.txt /home/vscode/

# Copy .radian_profile file into ~/ directory
COPY .radian_profile /home/vscode/

# Copy .Rprofile file into ~/ directory
COPY .Rprofile /home/vscode/

# Change ownership of the files
RUN chown vscode:vscode /home/vscode/.zshrc /home/vscode/.p10k.zsh /home/vscode/.zsh_plugins.txt /home/vscode/.radian_profile /home/vscode/.Rprofile

# Switch to 'vscode' user
USER vscode

# Create a directory for R packages
RUN mkdir -p /home/vscode/R/Library

RUN echo "R_LIBS='/home/vscode/R/Library:\${R_LIBS}'" >> /home/vscode/.Renviron

# Install 'pak' package
RUN R -q -e "install.packages('pak', repos='http://cran.rstudio.com/')"

# Use 'pak' to install other packages
RUN R -q -e "pak::pkg_install('languageserver')"
RUN R -q -e "pak::pkg_install('httpgd')"
RUN R -q -e "pak::pkg_install('jsonlite')"
RUN R -q -e "pak::pkg_install('rlang')"

# If arch is x86_64, install TinyTeX with quarto,
# otherwise, install TinyTeX with tinytex::install_tinytex()
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        quarto install tinytex; \
    else \
        R -q -e "pak::pkg_install('tinytex')"; \
        R -q -e "tinytex::install_tinytex()"; \
    fi

# Clean up
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install Antidote
RUN git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
