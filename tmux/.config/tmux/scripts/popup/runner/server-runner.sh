#!/usr/bin/env zsh

# {{{ discover_server_scripts
# Print npm/Yarn script names that look like long-running app servers.
discover_server_scripts() {
    local package_json="$1"

    [[ -f "$package_json" ]] || return 0

    jq -r '
        (.scripts // {} | keys[])
        | select(test("^(dev|start|serve|server|watch|preview)(:.*)?$"; "i"))
    ' "$package_json" 2>/dev/null
}
# }}}

# {{{ server_package_manager
server_package_manager() {
    local project_dir="$1"

    if [[ -f "$project_dir/pnpm-lock.yaml" ]] && command -v pnpm >/dev/null 2>&1; then
        print -r -- pnpm
    elif [[ -f "$project_dir/yarn.lock" ]] && command -v yarn >/dev/null 2>&1; then
        print -r -- yarn
    elif command -v npm >/dev/null 2>&1; then
        print -r -- npm
    elif command -v yarn >/dev/null 2>&1; then
        print -r -- yarn
    fi
}
# }}}

# {{{ detect_project_type
# Return a short description for unsupported project manifests.
detect_project_type() {
    local project_dir="$1"

    if [[ -f "$project_dir/package.json" ]]; then
        print -r -- "Node.js project (package.json)"
    elif [[ -f "$project_dir/pyproject.toml" || -f "$project_dir/requirements.txt" ]]; then
        print -r -- "Python project"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        print -r -- "Rust project"
    elif [[ -f "$project_dir/go.mod" ]]; then
        print -r -- "Go project"
    elif [[ -f "$project_dir/Gemfile" ]]; then
        print -r -- "Ruby project"
    elif [[ -f "$project_dir/Makefile" ]]; then
        print -r -- "Make-based project"
    else
        print -r -- "Unknown project type"
    fi
}
# }}}

# {{{ run_server
run_server() {
    local project_dir="${1:-$PWD}"
    local package_json="$project_dir/package.json"
    local project_type
    local package_manager
    local -a server_scripts
    local selected_script

    if [[ ! -d "$project_dir" ]]; then
        print -u2 -- "Server runner: project directory does not exist: $project_dir"
        return 1
    fi
    cd -- "$project_dir" || return 1

    project_type="$(detect_project_type "$project_dir")"
    if [[ ! -f "$package_json" ]]; then
        print -- "Server runner: detected $project_type, but automatic server command discovery is currently supported for Node.js package scripts."
        print -- "Use this window as a shell to start the project manually."
        exec zsh -i
    fi

    package_manager="$(server_package_manager "$project_dir")"
    if [[ -z "$package_manager" ]]; then
        print -- "Server runner: $project_type detected, but npm and Yarn are unavailable."
        print -- "Use this window as a shell to start the project manually."
        exec zsh -i
    fi

    server_scripts=("${(@f)$(discover_server_scripts "$package_json")}")
    if (( ${#server_scripts[@]} == 0 )); then
        print -- "Server runner: no likely server scripts found in $package_json."
        print -- "Use this window as a shell to start the project manually."
        exec zsh -i
    fi

    if (( ${#server_scripts[@]} == 1 )); then
        selected_script="${server_scripts[1]}"
    else
        if ! command -v fzf >/dev/null 2>&1; then
            print -- "Server runner: multiple server scripts found, but fzf is unavailable."
            print -- "Use this window as a shell to start the project manually."
            exec zsh -i
        fi
        selected_script="$(printf '%s\n' "${server_scripts[@]}" | fzf \
            --prompt="Server script > " \
            --header="$project_type · $package_manager" \
            --height=40% \
            --layout=reverse)" || return 0
        [[ -n "$selected_script" ]] || return 0
    fi

    print -- "Starting server: $package_manager run $selected_script"
    if [[ "$package_manager" == "npm" ]]; then
        npm run "$selected_script"
    else
        "$package_manager" run "$selected_script"
    fi
}
# }}}

if [[ "$ZSH_EVAL_CONTEXT" != *:file ]]; then
    run_server "${1:-$PWD}"
fi
