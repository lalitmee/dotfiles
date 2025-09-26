# Use a recent Ubuntu LTS version as the base image
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal prerequisites for bootstrapping
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    curl \
    zsh \
    stow \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN adduser --disabled-password --gecos "" myuser && \
    usermod -aG sudo myuser
RUN echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the non-root user
USER myuser
WORKDIR /home/myuser

# --- Bootstrap Step 1: Install GUM ---
# Install gum via its .deb package to avoid Go versioning issues.
RUN wget https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_amd64.deb && \
    sudo dpkg -i gum_0.13.0_amd64.deb && \
    rm gum_0.13.0_amd64.deb

# Copy the entire dotfiles repository
COPY --chown=myuser:myuser . /home/myuser/dotfiles

# Set working directory
WORKDIR /home/myuser/dotfiles

# --- Bootstrap Step 2: Stow BIN ---
# Stow the 'bin' directory first to make all helper scripts available on the PATH.
RUN stow -D bin && stow bin
ENV PATH="/home/myuser/.config/bin:${PATH}"

# Make all installer scripts executable
RUN chmod +x ./scripts/install/phases/*.zsh
RUN chmod +x ./scripts/test/verify-installation.sh

# --- Execute Test ---
# Now that helper scripts are on the PATH, run the installation phases directly.
ENV NON_INTERACTIVE_MODE=true
RUN ./scripts/install/phases/00-base-ubuntu.zsh && \
    ./scripts/install/phases/03-system-foundation.zsh && \
    ./scripts/install/phases/04-development-core.zsh && \
    ./scripts/install/phases/07-config-stow.zsh

# --- Verify ---
# Run the verification script to confirm tools are installed.
RUN ./scripts/test/verify-installation.sh

# Set the default command
CMD ["/usr/bin/zsh"]