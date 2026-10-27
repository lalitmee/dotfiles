#!/usr/bin/env zsh

# Preserve truecolor in gum output even when styling is captured through a pipe.
export CLICOLOR_FORCE=1
export FORCE_COLOR=1

# {{{ discover_server_scripts
# Print package scripts that look like long-running app servers.
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
detect_project_type() {
    local project_dir="$1"

    if [[ -f "$project_dir/package.json" ]]; then
        print -r -- "Node.js project"
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

# {{{ install_server_dependencies
install_server_dependencies() {
    local project_dir="$1"
    local package_manager="$2"

    [[ -d "$project_dir/node_modules" ]] && return 0

    print -- "Installing dependencies with $package_manager..."
    case "$package_manager" in
        pnpm) pnpm install ;;
        yarn) yarn install ;;
        npm) npm install ;;
        *) return 1 ;;
    esac
}
# }}}

# {{{ server_action_key
server_action_key() {
    local index="$1"
    local -a keys=(1 2 3 4 5 6 7 8 9 0 a b c d e f g h i j k l m n o p r s t u v w x y z)
    print -r -- "${keys[$index]:-}"
}

resolve_server_key() {
    local key="${1:l}"
    local index
    for (( index = 1; index <= ${#server_scripts[@]}; index++ )); do
        if [[ "$(server_action_key "$index")" == "$key" ]]; then
            print -r -- "$index"
            return 0
        fi
    done
    return 1
}
# }}}

# {{{ centered palette rendering
server_hex_fg() {
    local hex="${1#\#}"
    printf '\e[38;2;%d;%d;%dm' "$(( 16#${hex[1,2]} ))" "$(( 16#${hex[3,4]} ))" "$(( 16#${hex[5,6]} ))"
}

server_terminal_geometry() {
    local cols lines
    if [[ -n "${TMUX:-}" ]]; then
        cols="$(tmux display-message -p '#{pane_width}' 2>/dev/null || print 100)"
        lines="$(tmux display-message -p '#{pane_height}' 2>/dev/null || print 30)"
    else
        cols="$(tput cols 2>/dev/null || print 100)"
        lines="$(tput lines 2>/dev/null || print 30)"
    fi
    print -r -- "$cols $lines"
}

center_server_line() {
    local content="$1"
    local visible_length="$2"
    local width="$3"
    local padding=$(( (width - visible_length) / 2 ))
    (( padding < 0 )) && padding=0
    printf '%*s%b' "$padding" '' "$content"
}

render_server_menu() {
    local project_type="$1"
    local package_manager="$2"
    local geometry cols lines card_width inner_width index key script
    local c_header c_accent c_muted c_key c_border c_worktree c_branch c_row
    local plain colored separator branch_name script_width command_width hint_width
    local script_label command_label script_cell command_cell hint
    local card_content card_box card_height pad_top margin_h
    local -a card_lines=()

    if ! command -v gum >/dev/null 2>&1; then
        print -u2 -- "Server palette requires gum."
        return 1
    fi

    geometry="$(server_terminal_geometry)"
    cols="${geometry%% *}"
    lines="${geometry##* }"
    card_width=78
    (( cols < card_width + 4 )) && card_width=$(( cols - 4 ))
    (( card_width < 48 )) && card_width=48
    inner_width=$(( card_width - 8 ))
    script_width=18
    hint_width=9
    if (( inner_width < 60 )); then
        script_width=12
        hint_width=0
    fi
    command_width=$(( inner_width - 1 - 3 - 4 - script_width - 3 - 3 - hint_width ))
    (( hint_width == 0 )) && command_width=$(( command_width + 3 ))

    c_header="$(server_hex_fg '#FFC600')"
    c_accent="$(server_hex_fg '#00AAFF')"
    c_muted="$(server_hex_fg '#9E9E9E')"
    c_key="$(server_hex_fg '#FFC600')"
    c_border="$(server_hex_fg '#185294')"
    c_worktree="$(server_hex_fg '#80FCFF')"
    c_branch="$(server_hex_fg '#3AD900')"
    separator="${c_border}$(printf '─%.0s' {1..$inner_width})\e[0m"
    branch_name="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || print -r -- detached)"

    card_lines+=("$(center_server_line "\e[1m${c_header}Workmux Server Launcher\e[0m" 23 "$inner_width")")
    card_lines+=("")
    plain="Worktree: ${PWD:t}   •   Branch:  $branch_name"
    colored="${c_accent}Worktree: \e[1m${c_worktree}${PWD:t}\e[0m   ${c_border}•\e[0m   ${c_accent}Branch: \e[1m${c_branch} $branch_name\e[0m"
    card_lines+=("$(center_server_line "$colored" "${#plain}" "$inner_width")")
    card_lines+=("$separator" "")

    for (( index = 1; index <= ${#server_scripts[@]}; index++ )); do
        key="$(server_action_key "$index")"
        script="${server_scripts[$index]}"
        case "$(( (index - 1) % 5 ))" in
            0) c_row="$(server_hex_fg '#00AAFF')" ;;
            1) c_row="$(server_hex_fg '#3AD900')" ;;
            2) c_row="$(server_hex_fg '#FFC600')" ;;
            3) c_row="$(server_hex_fg '#80FCFF')" ;;
            4) c_row="$(server_hex_fg '#EE80E1')" ;;
        esac
        script_label="$script"
        if (( ${#script_label} > script_width )); then
            script_label="${script_label[1,$(( script_width - 1 ))]}…"
        fi
        command_label="$package_manager run $script"
        if (( ${#command_label} > command_width )); then
            command_label="${command_label[1,$(( command_width - 1 ))]}…"
        fi
        printf -v script_cell '%-*s' "$script_width" "$script_label"
        printf -v command_cell '%-*s' "$command_width" "$command_label"
        colored=" ${c_border}[\e[1m${c_row}${key}\e[0m${c_border}]    \e[1m${c_row}${script_cell}\e[0m   ${c_muted}${command_cell}\e[0m"
        if (( hint_width > 0 )); then
            printf -v hint '%-*s' "$hint_width" "press $key"
            colored+="   ${c_row}${hint}\e[0m"
        fi
        card_lines+=("$colored")
    done

    card_lines+=("" "$separator")
    plain='[Enter] Default  •  [q] Shell'
    colored="${c_border}[\e[1m${c_key}Enter\e[0m${c_border}]${c_muted} Default  ${c_border}•  ${c_border}[\e[1m${c_accent}q\e[0m${c_border}]${c_muted} Shell\e[0m"
    card_lines+=("$(center_server_line "$colored" "${#plain}" "$inner_width")")

    card_content="$(printf '%b\n' "${card_lines[@]}")"
    card_box="$(gum style --border rounded --border-foreground '#00AAFF' --padding '1 2' --width "$card_width" "$card_content")"
    card_height="$(printf '%s\n' "$card_box" | wc -l | tr -d ' ')"
    pad_top=0
    (( lines > card_height )) && pad_top=$(( (lines - card_height) / 2 ))
    margin_h=0
    (( cols > card_width )) && margin_h=$(( (cols - card_width) / 2 ))

    clear
    for (( index = 1; index <= pad_top; index++ )); do print; done
    gum style --margin "0 $margin_h" "$card_box"
}
# }}}

# {{{ read_server_key
read_server_key() {
    local key=""
    read -r -k 1 key || return 1
    if [[ "$key" == $'\e' ]]; then
        local rest=""
        while read -r -k 1 -t 0.02 rest 2>/dev/null; do key+="$rest"; done
    fi
    print -r -- "$key"
}
# }}}

# {{{ run_server
run_server() {
    local project_dir="${1:-$PWD}"
    local package_json="$project_dir/package.json"
    local project_type package_manager selected_key selected_index selected_script
    local -a server_scripts

    if [[ ! -d "$project_dir" ]]; then
        print -u2 -- "Server runner: project directory does not exist: $project_dir"
        return 1
    fi
    cd -- "$project_dir" || return 1

    project_type="$(detect_project_type "$project_dir")"
    if [[ ! -f "$package_json" ]]; then
        print -- "Server runner: detected $project_type; automatic server command discovery supports Node.js package scripts only."
        exec zsh -i
    fi

    package_manager="$(server_package_manager "$project_dir")"
    if [[ -z "$package_manager" ]]; then
        print -- "Server runner: npm, pnpm, or Yarn is unavailable."
        exec zsh -i
    fi

    if ! install_server_dependencies "$project_dir" "$package_manager"; then
        print -u2 -- "Server runner: dependency installation failed."
        exec zsh -i
    fi

    server_scripts=("${(@f)$(discover_server_scripts "$package_json")}")
    if (( ${#server_scripts[@]} == 0 )); then
        print -- "Server runner: no likely server scripts found in $package_json."
        exec zsh -i
    fi

    render_server_menu "$project_type" "$package_manager" || exec zsh -i
    selected_key="$(read_server_key)" || selected_key=''
    case "$selected_key" in
        ''|$'\n'|$'\r') selected_index=1 ;;
        q|Q|$'\e') exec zsh -i ;;
        *) selected_index="$(resolve_server_key "$selected_key")" || selected_index='' ;;
    esac
    [[ -n "$selected_index" ]] || exec zsh -i
    selected_script="${server_scripts[$selected_index]}"

    clear
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
