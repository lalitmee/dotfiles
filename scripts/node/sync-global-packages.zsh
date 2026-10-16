#!/usr/bin/env zsh
# sync-global-packages.zsh
# Installs all global npm packages defined in node/global-packages.txt
# for the currently active Node version managed by fnm.
#
# Usage:
#   zsh scripts/node/sync-global-packages.zsh             # sync active version
#   zsh scripts/node/sync-global-packages.zsh --version 22 # sync a specific version

# {{{ resolve paths

SCRIPT_DIR="${0:A:h}"
DOTFILES_DIR="${SCRIPT_DIR:h:h}"
PACKAGES_FILE="$DOTFILES_DIR/node/global-packages.txt"

# }}}

# {{{ helpers

_info()  { print -P "%F{cyan}ℹ%f  $*" }
_ok()    { print -P "%F{green}✔%f  $*" }
_warn()  { print -P "%F{yellow}⚠%f  $*" >&2 }
_error() { print -P "%F{red}✖%f  $*" >&2 }

# }}}

# {{{ parse args

TARGET_VERSION=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --version|-v)
            TARGET_VERSION="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--version <node-version>]"
            echo "  Installs all packages from node/global-packages.txt globally."
            echo "  Without --version, uses the currently active Node version."
            exit 0
            ;;
        *)
            _error "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# }}}

# {{{ validate environment

if ! command -v fnm &>/dev/null; then
    _error "fnm is not installed or not in PATH."
    exit 1
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
    _error "Packages file not found: $PACKAGES_FILE"
    exit 1
fi

# Build the list: strip comments and blank lines
packages=()
while IFS= read -r line; do
    line="${line%%#*}"   # strip inline comments
    line="${line// /}"   # strip spaces
    [[ -z "$line" ]] && continue
    packages+=("$line")
done < "$PACKAGES_FILE"

if [[ ${#packages[@]} -eq 0 ]]; then
    _warn "No packages found in $PACKAGES_FILE. Nothing to install."
    exit 0
fi

# }}}

# {{{ run install

if [[ -n "$TARGET_VERSION" ]]; then
    _info "Syncing global packages for Node $TARGET_VERSION..."
    node_display="v$TARGET_VERSION"
    run_npm() { fnm exec --using="$TARGET_VERSION" npm "$@" }
else
    _info "Syncing global packages for active Node $(node --version 2>/dev/null || echo '(unknown)')..."
    node_display="$(node --version 2>/dev/null || echo 'unknown')"
    run_npm() { npm "$@" }
fi

_info "Installing ${#packages[@]} packages from node/global-packages.txt..."
echo ""

failed=()
for pkg in "${packages[@]}"; do
    print -n "  → $pkg ... "
    if run_npm install -g "$pkg" &>/dev/null; then
        print -P "%F{green}done%f"
    else
        print -P "%F{red}FAILED%f"
        failed+=("$pkg")
    fi
done

echo ""

if [[ ${#failed[@]} -gt 0 ]]; then
    _warn "The following packages failed to install:"
    for pkg in "${failed[@]}"; do
        echo "    - $pkg"
    done
    exit 1
else
    _ok "All packages successfully installed for Node $node_display."
fi

# }}}
