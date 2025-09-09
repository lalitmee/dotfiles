#!/bin/bash
# Docker-based Testing Script for Dotfiles Installation
# This script provides a safe, isolated environment for testing the installation

set -e

# Configuration
CONTAINER_NAME="dotfiles-test"
IMAGE_NAME="ubuntu:24.04"
DOTFILES_REPO="https://github.com/lalitmee/dotfiles.git"
HOST_DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if container exists
container_exists() {
    docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

# Function to check if container is running
container_running() {
    docker ps --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

# Function to create fresh container
create_container() {
    log_info "Creating fresh test container..."

    # Remove existing container if it exists
    if container_exists; then
        log_warning "Removing existing container..."
        docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1
    fi

    # Create new container
    docker run -d --name "$CONTAINER_NAME" \
        --privileged \
        -v "$HOST_DOTFILES_DIR:/host-dotfiles:ro" \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        -e DISPLAY="$DISPLAY" \
        -e TERM="$TERM" \
        -e USER="$USER" \
        -e HOME="/home/testuser" \
        -w /home/testuser \
        "$IMAGE_NAME" \
        sleep infinity

    log_success "Container created successfully"
}

# Function to setup container environment
setup_container() {
    log_info "Setting up container environment..."

    # Update package list and install essentials
    docker exec "$CONTAINER_NAME" bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt update && apt upgrade -y
        apt install -y sudo git curl wget gnupg software-properties-common apt-transport-https
        apt install -y build-essential # For compiling packages
    "

    # Create test user
    docker exec "$CONTAINER_NAME" useradd -m -s /bin/bash testuser
    docker exec "$CONTAINER_NAME" usermod -aG sudo testuser
    docker exec "$CONTAINER_NAME" bash -c "echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

    log_success "Container environment setup complete"
}

# Function to clone dotfiles
clone_dotfiles() {
    log_info "Cloning dotfiles repository..."

    docker exec -u testuser "$CONTAINER_NAME" bash -c "
        cd /home/testuser
        git clone $DOTFILES_REPO dotfiles
        cd dotfiles
        chmod +x scripts/install/main-installer.zsh
        chmod +x scripts/install/phases/*.zsh
    "

    log_success "Dotfiles cloned and prepared"
}

# Function to run installation phase
run_installation_phase() {
    local phase="$1"
    log_info "Running installation phase: $phase"

    # Create wrapper script for proper PATH setup
    cat > /tmp/docker_wrapper.sh << 'EOF'
#!/bin/bash
export PATH="/home/testuser/.cargo/bin:/home/testuser/go/bin:$PATH"
cd /home/testuser/dotfiles
./scripts/install/main-installer.zsh
EOF
    chmod +x /tmp/docker_wrapper.sh

    # Copy wrapper to container
    docker cp /tmp/docker_wrapper.sh dotfiles-test:/tmp/docker_wrapper.sh

    # Create expect script for automated interaction
    cat > /tmp/docker_test.exp << 'EOF'
#!/usr/bin/expect -f
set timeout 300

spawn docker exec -it -u testuser dotfiles-test /tmp/docker_wrapper.sh

expect "What would you like to do?"
send "single-phase\r"

expect "Select phase to install:"
send "$phase\r"

expect eof
EOF

    chmod +x /tmp/docker_test.exp
    /tmp/docker_test.exp

    # Clean up
    rm -f /tmp/docker_test.exp

    log_success "Phase $phase completed"
}

# Function to run full installation
run_full_installation() {
    log_info "Running full installation..."

    # Create expect script for automated interaction
    cat > /tmp/docker_full_test.exp << EOF
#!/usr/bin/expect -f
set timeout 1800

spawn docker exec -it -u testuser $CONTAINER_NAME bash -c "cd /home/testuser/dotfiles && ./scripts/install/main-installer.zsh"

expect "What would you like to do?"
send "full-install\r"

expect "Starting complete installation..."
# Wait for completion
expect {
    "Installation completed successfully!" { send "\r" }
    "Installation failed" { send "\r" }
    timeout { send "\003" }
}

expect eof
EOF

    chmod +x /tmp/docker_full_test.exp
    /tmp/docker_full_test.exp

    # Clean up
    rm -f /tmp/docker_full_test.exp

    log_success "Full installation completed"
}

# Function to validate installation
validate_installation() {
    log_info "Validating installation..."

    docker exec -u testuser "$CONTAINER_NAME" bash -c "
        export PATH=\"\$HOME/.cargo/bin:\$HOME/go/bin:\$PATH\"

        echo '=== Installed Tools Check ==='
        which git && echo '✓ git installed' || echo '✗ git missing'
        which zsh && echo '✓ zsh installed' || echo '✗ zsh missing'
        which tmux && echo '✓ tmux installed' || echo '✗ tmux missing'
        which nvim && echo '✓ neovim installed' || echo '✗ neovim missing'
        which i3 && echo '✓ i3 installed' || echo '✗ i3 missing'
        which cargo && echo '✓ cargo installed' || echo '✗ cargo missing'
        which go && echo '✓ go installed' || echo '✗ go missing'
        which sesh && echo '✓ sesh installed' || echo '✗ sesh missing'

        echo ''
        echo '=== Configuration Check ==='
        ls -la ~/.zshrc 2>/dev/null && echo '✓ zshrc linked' || echo '✗ zshrc not linked'
        ls -la ~/.config/i3/config 2>/dev/null && echo '✓ i3 config linked' || echo '✗ i3 config not linked'
        ls -la ~/.tmux.conf 2>/dev/null && echo '✓ tmux config linked' || echo '✗ tmux config not linked'
    "

    log_success "Validation completed"
}

# Function to validate installation
validate_installation() {
    log_info "Validating installation..."

    docker exec -u testuser "$CONTAINER_NAME" bash -c "
        export PATH=\"\$HOME/.cargo/bin:\$HOME/go/bin:\$PATH\"

        echo '=== Installed Tools Check ==='
        which git && echo '✓ git installed' || echo '✗ git missing'
        which zsh && echo '✓ zsh installed' || echo '✗ zsh missing'
        which tmux && echo '✓ tmux installed' || echo '✗ tmux missing'
        which nvim && echo '✓ neovim installed' || echo '✗ neovim missing'
        which i3 && echo '✓ i3 installed' || echo '✗ i3 missing'
        which cargo && echo '✓ cargo installed' || echo '✗ cargo missing'
        which go && echo '✓ go installed' || echo '✗ go missing'
        which rg && echo '✓ ripgrep installed' || echo '✗ ripgrep missing'
        which bat && echo '✓ bat installed' || echo '✗ bat missing'
        which lsd && echo '✓ lsd installed' || echo '✗ lsd missing'
        which zoxide && echo '✓ zoxide installed' || echo '✗ zoxide missing'
        which atuin && echo '✓ atuin installed' || echo '✗ atuin missing'
        which sesh && echo '✓ sesh installed' || echo '✗ sesh missing'

        echo ''
        echo '=== Configuration Check ==='
        ls -la ~/.zshrc 2>/dev/null && echo '✓ zshrc linked' || echo '✗ zshrc not linked'
        ls -la ~/.config/i3/config 2>/dev/null && echo '✓ i3 config linked' || echo '✗ i3 config not linked'
        ls -la ~/.tmux.conf 2>/dev/null && echo '✓ tmux config linked' || echo '✗ tmux config not linked'
    "

    log_success "Validation completed"
}

# Function to enter container for manual testing
enter_container() {
    log_info "Entering container for manual testing..."
    log_info "Type 'exit' to leave the container"
    docker exec -it -u testuser "$CONTAINER_NAME" bash
}

# Function to cleanup
cleanup() {
    log_info "Cleaning up..."

    if container_running; then
        docker stop "$CONTAINER_NAME" >/dev/null 2>&1
    fi

    if container_exists; then
        docker rm "$CONTAINER_NAME" >/dev/null 2>&1
    fi

    log_success "Cleanup completed"
}

# Function to show usage
show_usage() {
    echo "Docker-based Testing Script for Dotfiles Installation"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup          - Create and setup test container"
    echo "  phase <num>    - Run specific installation phase (0-8)"
    echo "  full           - Run complete installation"
    echo "  validate       - Validate installation results"
    echo "  enter          - Enter container for manual testing"
    echo "  cleanup        - Remove test container"
    echo "  reset          - Reset container to clean state"
    echo "  status         - Show container status"
    echo ""
    echo "Examples:"
    echo "  $0 setup                    # Setup test environment"
    echo "  $0 phase 0                  # Test Phase 0 (base system)"
    echo "  $0 phase 3                  # Test Phase 3 (system foundation)"
    echo "  $0 full                     # Run complete installation"
    echo "  $0 validate                 # Check installation results"
    echo "  $0 enter                    # Manual testing"
    echo "  $0 cleanup                  # Clean up"
}

# Main script logic
case "${1:-help}" in
    "setup")
        create_container
        setup_container
        clone_dotfiles
        log_success "Test environment is ready!"
        log_info "Run '$0 phase 0' to start testing Phase 0"
        ;;

    "phase")
        if [ -z "$2" ]; then
            log_error "Please specify a phase number (0-8)"
            exit 1
        fi

        if ! container_exists; then
            log_error "Test container not found. Run '$0 setup' first."
            exit 1
        fi

        if ! container_running; then
            log_info "Starting container..."
            docker start "$CONTAINER_NAME" >/dev/null 2>&1
        fi

        run_installation_phase "$2"
        ;;

    "full")
        if ! container_exists; then
            log_error "Test container not found. Run '$0 setup' first."
            exit 1
        fi

        if ! container_running; then
            log_info "Starting container..."
            docker start "$CONTAINER_NAME" >/dev/null 2>&1
        fi

        run_full_installation
        ;;

    "validate")
        if ! container_exists; then
            log_error "Test container not found. Run '$0 setup' first."
            exit 1
        fi

        if ! container_running; then
            log_info "Starting container..."
            docker start "$CONTAINER_NAME" >/dev/null 2>&1
        fi

        validate_installation
        ;;

    "enter")
        if ! container_exists; then
            log_error "Test container not found. Run '$0 setup' first."
            exit 1
        fi

        if ! container_running; then
            log_info "Starting container..."
            docker start "$CONTAINER_NAME" >/dev/null 2>&1
        fi

        enter_container
        ;;

    "cleanup")
        cleanup
        ;;

    "reset")
        log_info "Resetting container to clean state..."
        cleanup
        create_container
        setup_container
        clone_dotfiles
        log_success "Container reset complete"
        ;;

    "status")
        if container_exists; then
            if container_running; then
                log_success "Container is running"
                docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            else
                log_warning "Container exists but is not running"
                docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}"
            fi
        else
            log_info "No test container found"
        fi
        ;;

    "help"|*)
        show_usage
        ;;
esac