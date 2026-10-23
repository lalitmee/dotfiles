#!/usr/bin/env zsh

source "${${(%):-%x}:A:h}/lib/popup-style.sh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/config.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/discovery.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/actions.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/popup.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/creation.zsh"

# Absolute path to this script, reused when the picker opens a popup that
# re-invokes us through the __action subcommand.
typeset -g WM_SELF="${${(%):-%x}:A}"

# EPOCHSECONDS and zstat back the discovery cache freshness check.
zmodload zsh/datetime zsh/stat 2>/dev/null

# Escape control characters for single-line display; original fields stay in arrays.
manager_display() { print -rn -- "${(V)1}"; }

# Format paths for display, contracting $HOME to ~/ while escaping controls. # {{{
manager_display_path() {
    emulate -L zsh
    local p="$1"
    if [[ "$p" == "$HOME" ]]; then
        print -rn -- '~'
    elif [[ "$p" == "$HOME/"* ]]; then
        manager_display "~/${p#$HOME/}"
    else
        manager_display "$p"
    fi
}
# }}}

# Cobalt2 palette (RGB format matching window-switcher.sh, prioritized for visibility)
typeset -ga WM_COBALT2_PALETTE=(
    '255;198;0' '0;170;255' '58;217;0' '255;98;140'
    '255;157;0' '128;252;255' '150;126;251' '238;128;225'
    '242;237;127' '187;255;221' '251;188;5' '66;133;244'
    '52;168;83' '234;67;53'
)

# Assign Cobalt2 colors to displayed repositories without repetition. # {{{
_worktree_assign_repo_colors() {
    emulate -L zsh
    local color rgb item r_parts r_root
    local color_idx=0 extra=0
    local p r g b lum

    repo_colors=()
    used_colors=()
    for p in "${WM_COBALT2_PALETTE[@]}"; do used_colors[$p]=1; done

    for item in "${sorted_entries[@]}"; do
        r_parts=("${(@ps:\t:)item}")
        r_root="${r_parts[5]}"
        if [[ -z "${repo_colors[$r_root]:-}" ]]; then
            (( color_idx++ ))
            color="${WM_COBALT2_PALETTE[color_idx]:-}"
            while [[ -z "$color" || ( $color_idx -gt ${#WM_COBALT2_PALETTE} && -n "${used_colors[$color]:-}" ) ]]; do
                (( extra++ ))
                rgb=$(( (8421504 + extra * 7919) % 16777216 ))
                r=$(( rgb / 65536 ))
                g=$(( (rgb / 256) % 256 ))
                b=$(( rgb % 256 ))
                lum=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
                if (( lum < 130 )); then
                    continue
                fi
                color="${r};${g};${b}"
            done
            used_colors[$color]=1
            repo_colors[$r_root]="$color"
        fi
    done
}
# }}}

worktree_manager_header() {
    emulate -L zsh
    local filter_label="${1:-all}" main_label="${2:-off}" width="${COLUMNS:-80}"
    local key_color=$popup_key description_color=$popup_value reset_color=$popup_reset
    local header='' binding key description line_width=0
    local -a bindings=(
        'enter: open window' 'ctrl-s: open session' 'ctrl-b: checkout' 'ctrl-r: rename'
        'ctrl-d: remove' "ctrl-g: filter:${filter_label}" "ctrl-t: mains:${main_label}"
        'ctrl-f: refresh' 'ctrl-o: create worktree' 'esc: quit'
    )
    for binding in "${bindings[@]}"; do
        if (( line_width )); then
            if (( line_width + 3 + ${#binding} > width )); then
                header+=$'\n'
                line_width=0
            else
                header+=' | '
                (( line_width += 3 ))
            fi
        fi
        key="${binding%%:*}"
        description="${binding#*: }"
        header+="${key_color}${key}:${reset_color} ${description_color}${description}${reset_color}"
        (( line_width += ${#binding} ))
    done
    print -r -- "$header"
}

manager_confirm() {
    local affirmative="${2:+Yes, ${2}}"
    affirmative="${affirmative:-Yes}"
    if _worktree_popup_gum; then
        gum confirm \
            --prompt.foreground="$WM_HIGHLIGHT" \
            --selected.foreground="#FFFFFF" --selected.background="$WM_SELECT_BG" \
            --unselected.foreground="#8a8a8a" \
            --affirmative="$affirmative" --negative="Cancel" \
            "$1"
        return
    fi
    local answer
    print -r -- "$1"
    print -n -r -- "Type ${2:-yes} to confirm: "
    IFS= read -r answer || return 1
    [[ "$answer" == "${2:-yes}" ]]
}

# feedback is dynamically scoped by manager_main; prompts run outside this capture.
manager_run_action() {
    local diagnostic
    if diagnostic=$("$@" 2>&1); then
        return 0
    fi
    feedback="$diagnostic"
    return 1
}

manager_validate() {
    local diagnostic_file
    diagnostic_file=$(mktemp "${TMPDIR:-/tmp}/worktree-ui-validate.XXXXXXXX") || return 1
    if _worktree_manager_validate "$@" 2> "$diagnostic_file"; then
        rm -f -- "$diagnostic_file"
        return 0
    fi
    feedback="$(< "$diagnostic_file")"
    rm -f -- "$diagnostic_file"
    return 1
}

manager_checkout() {
    emulate -L zsh
    local repo="$1" selected="$2" field output id tracking=0
    local wm_action_status wm_action_flags
    local -a branches refs kinds names rows locals
    manager_validate "$repo" "$selected" || return 1
    while IFS= read -r -d '' field; do branches+=("$field"); done < <(list_repository_branches "$repo")
    local i
    for ((i=1; i<=${#branches}; i+=4)); do
        [[ "${branches[i+1]}" == local ]] && locals+=("${branches[i+2]}")
    done
    for ((i=1; i<=${#branches}; i+=4)); do
        [[ -n "${branches[i+3]}" && "${branches[i+3]:A}" != "${selected:A}" ]] && continue
        if [[ "${branches[i+1]}" == remote ]]; then
            (( ${locals[(Ie)${branches[i+2]#*/}]} )) && continue
        fi
        refs+=("${branches[i]}"); kinds+=("${branches[i+1]}"); names+=("${branches[i+2]}")
        rows+=("${#refs}"$'\t'"$(manager_display "${branches[i+2]}") [${branches[i+1]}]")
    done
    (( ${#rows} )) || { feedback='No available branches.'; return 1; }
    output=$(printf '%s\n' "${rows[@]}" | fzf --delimiter=$'\t' --with-nth=2.. --header='Select branch; remote selections create a local tracking branch' --no-multi) || return 1
    id="${output%%$'\t'*}"
    [[ "$id" == <-> ]] && (( id>=1 && id<=${#refs} )) || return 1
    # Recheck immediately before confirmation so safety copy reflects current state.
    manager_validate "$repo" "$selected" || return 1
    if [[ "$wm_action_status" == dirty ]]; then
        manager_confirm "Checkout ${names[id]} in path: $selected
Status: $wm_action_status. Local changes may conflict with checkout." || return 1
    fi
    [[ "${kinds[id]}" == remote ]] && tracking=1
    manager_run_action checkout_branch "$repo" "$selected" "${refs[id]}" "$tracking"
}

manager_mutation() {
    emulate -L zsh
    local action="$1" repo="$2" selected="$3" destination force=0 manager_window
    local wm_action_status wm_action_flags
    manager_validate "$repo" "$selected" || return 1
    [[ ",$wm_action_flags," != *,main,* ]] || {
        if [[ "$action" == ctrl-r ]]; then
            feedback='Main worktree cannot be renamed.'
        else
            feedback='Main worktree cannot be removed.'
        fi
        return 1
    }
    if [[ "$action" == ctrl-r ]]; then
        destination=$(worktree_popup_destination "$selected") || return 1
        manager_confirm "Move path: $selected
Status: $wm_action_status
Destination: $destination" || return 1
        manager_run_action rename_worktree "$repo" "$selected" "$destination"
    else
        manager_confirm "Remove path: $selected
Status: $wm_action_status
The branch will be retained." || return 1
        # Status can change while the first prompt is open.
        manager_validate "$repo" "$selected" || return 1
        if [[ "$wm_action_status" == dirty ]]; then
            manager_confirm "FORCE removal discards tracked and untracked changes.
Path: $selected
Status: $wm_action_status" force || return 1
            force=1
        fi
        manager_window=$(tmux display-message -p '#{window_id}') || {
            feedback='Could not identify manager window for deletion.'
            return 1
        }
        tmux new-window -n "delete:${selected:t}" -c "$repo" \
            "zsh ${(qq)WM_SELF} __remove ${(qq)repo} ${(qq)selected} ${(qq)force} ${(qq)manager_window}" || {
                feedback='Could not open worktree deletion window.'
                return 1
            }
    fi
}

manager_launch() {
    emulate -L zsh
    local id name current
    current=$(tmux display-message -p '#{window_id}') || return 1
    while IFS=$'\t' read -r id name; do
        if [[ "$name" == worktree-manager ]]; then
            if [[ "$id" != "$current" ]]; then
                tmux set-window-option -t "$id" @worktree-manager-return "$current" || return 1
            fi
            tmux select-window -t "$id"
            return
        fi
    done < <(tmux list-windows -F '#{window_id}'$'\t''#{window_name}')
    tmux new-window -n worktree-manager -c "$HOME/Projects" -e "WM_RETURN_WINDOW=$current" "zsh ${(q)${${(%):-%x}:A}}"
}

manager_main() {
    emulate -L zsh
    local projects_root field output key id header refresh=1 force=0 return_window feedback='' action_output diagnostics picker_status filter=all show_main=0 notice_level notice_message root cache_id
    local -a roots
    if (( $# )); then
        for root in "$@"; do roots+=("${root:A}"); done
    else
        while IFS= read -r -d '' root; do roots+=("$root"); done < <(load_worktree_roots)
    fi
    projects_root="${(j:, :)roots}"
    local heading_color=$popup_label reset_color=$popup_reset
    local -a fields rows choice
    local -A repo_colors used_colors
    while true; do
        if (( refresh )); then
            fields=(); rows=()
            # Cache the raw NUL records (they back the actions too). Version the
            # filename so a record-format change never reads a stale cache.
            # ponytail: key is the sanitized projects root and TTL caps staleness
            # at WM_CACHE_TTL (default 90s); ctrl-f and post-action refresh
            # always rescan, and actions re-validate before touching anything.
            cache_id=$(printf '%s\0' "${roots[@]}" | cksum)
            cache_id="${cache_id%% *}"
            local cache_file="${TMPDIR:-/tmp}/worktree-manager-cache.v7.${cache_id}"
            local use_cache=0
            local -a cstat
            if (( ! force )) && [[ -r "$cache_file" ]] &&
                zstat -A cstat +mtime -- "$cache_file" 2>/dev/null &&
                (( EPOCHSECONDS - cstat[1] < ${WM_CACHE_TTL:-90} )); then
                use_cache=1
            fi
            if (( use_cache )); then
                while IFS= read -r -d '' field; do fields+=("$field"); done < "$cache_file"
            else
                diagnostics=$(mktemp "${TMPDIR:-/tmp}/worktree-ui.XXXXXXXX") || return 1
                local cache_tmp; cache_tmp=$(mktemp "${cache_file}.XXXX") || return 1
                if _worktree_popup_gum; then
                    # Spinner renders to the tty; records/diagnostics are written
                    # by the child's own redirects so nothing pollutes the stream.
                    gum spin --spinner dot \
                        --spinner.foreground="$WM_ACCENT" \
                        --title.foreground="$WM_HIGHLIGHT" \
                        --title "Scanning worktrees under $projects_root…" -- \
                        zsh -c 'script=$1; output=$2; errors=$3; shift 3; zsh "$script" __discover "$@" > "$output" 2> "$errors"' \
                        _ "$WM_SELF" "$cache_tmp" "$diagnostics" "${roots[@]}"
                else
                    discover_worktrees "${roots[@]}" 2> "$diagnostics" > "$cache_tmp"
                fi
                [[ -s "$diagnostics" ]] && feedback="$(< "$diagnostics")"
                rm -f -- "$diagnostics"
                while IFS= read -r -d '' field; do fields+=("$field"); done < "$cache_tmp"
                mv -f -- "$cache_tmp" "$cache_file" 2>/dev/null || rm -f -- "$cache_tmp"
            fi
            rows=()
            local -a raw_entries sorted_entries
            raw_entries=(); sorted_entries=()
            local i display tab=$'\t'
            for ((i=1; i+5<=${#fields}; i+=6)); do
                local group="${fields[i+1]}"
                if [[ "$filter" != all ]]; then
                    [[ "${group:l}" == "${filter:l}" ]] || continue
                fi
                [[ ",${fields[i+5]}," != *,prunable,* ]] || continue
                (( show_main )) || [[ ",${fields[i+5]}," != *,main,* ]] || continue
                raw_entries+=("$(manager_display "${fields[i+2]}")${tab}$(manager_display "${fields[i+4]:-detached}")${tab}$(manager_display_path "${fields[i+3]}")${tab}${i}${tab}${fields[i]}")
            done

            # Parallel discovery returns records in nondeterministic order; sort
            # by repo name, branch, and path before applying ANSI formatting so
            # ANSI escape codes do not corrupt the sort order.
            (( ${#raw_entries} )) && sorted_entries=("${(@f)$(printf '%s\n' "${raw_entries[@]}" | LC_ALL=C sort -t"$tab" -k1,1 -k2,2 -k3,3)}")

            _worktree_assign_repo_colors

            local entry
            for entry in "${sorted_entries[@]}"; do
                local -a entry_parts
                entry_parts=("${(@ps:\t:)entry}")
                local r_name="${entry_parts[1]}" r_branch="${entry_parts[2]}" r_path="${entry_parts[3]}" r_id="${entry_parts[4]}" r_root="${entry_parts[5]}"
                local r_color="${repo_colors[$r_root]:-${WM_COBALT2_PALETTE[1]}}"
                printf -v display '\033[1;38;2;%sm%-20.20s\033[0m %-32.32s %s' \
                    "$r_color" \
                    "$r_name" \
                    "$r_branch" \
                    "$r_path"
                rows+=("$r_id"$'\t'"$display")
            done
            refresh=0; force=0
        fi
        local filter_label="$filter"
        local main_label=off
        (( show_main )) && main_label=on
        header="$(worktree_manager_header "$filter_label" "$main_label")"
        notice_level=info
        notice_message=''
        if [[ -n "$feedback" ]]; then
            notice_level=warning
            notice_message="$feedback"
            feedback=''
        fi
        if (( ${#rows} == 0 )); then
            [[ -z "$notice_message" ]] || notice_message+=$'\n\n'
            notice_message+="No worktrees to show under $projects_root (filter: ${filter_label}; main: ${main_label})."
        fi
        [[ -z "$notice_message" ]] || manager_show_notice "$notice_level" "$notice_message"
        picker_status=0
        output=$({
            printf '0\t%s\n' "${heading_color}REPOSITORY           BRANCH                           PATH${reset_color}"
            (( ${#rows} )) && printf '%s\n' "${rows[@]}"
        } | fzf --ansi \
            --delimiter=$'\t' \
            --with-nth=2.. \
            --header-lines=1 \
            --no-multi \
            --expect=enter,ctrl-s,ctrl-b,ctrl-r,ctrl-d,ctrl-g,ctrl-t,ctrl-f,ctrl-o \
            --bind=esc:abort,ctrl-c:abort \
            --header="$header") || picker_status=$?
        choice=("${(@f)output}"); key="${choice[1]:-}"
        # An expected refresh key can accompany status 1 when no result matches.
        if [[ "$key" == ctrl-f ]] && (( picker_status == 0 || picker_status == 1 )); then
            refresh=1; force=1
            continue
        fi
        if [[ "$key" == ctrl-o ]] && (( picker_status == 0 )); then
            manager_launch_create || feedback='Could not open worktree creation window.'
            continue
        fi
        if [[ "$key" == ctrl-g ]]; then
            case "$filter" in
                all) filter=Personal ;;
                Personal) filter=Work ;;
                Work) filter=all ;;
            esac
            refresh=1
            continue
        fi
        if [[ "$key" == ctrl-t ]]; then
            (( show_main = 1 - show_main ))
            refresh=1
            continue
        fi
        (( picker_status == 0 )) || break
        [[ "$key" == enter || "$key" == ctrl-s || "$key" == ctrl-b || "$key" == ctrl-r || "$key" == ctrl-d ]] || continue
        id="${${choice[2]:-}%%$'\t'*}"
        [[ "$id" == <-> ]] && (( id>=1 && id<=${#fields} )) || continue
        i=$id
        feedback=''
        # Confirmation prompts use the terminal directly; action diagnostics are
        # shown in an acknowledging popup before the picker returns.
        case "$key" in
            enter)
                if ! action_output=$(open_worktree "${fields[i+3]}" "${fields[i+2]}" "${fields[i+4]}" window 2>&1); then
                    feedback="Open failed: $action_output"
                fi ;;
            ctrl-s)
                if ! action_output=$(open_worktree "${fields[i+3]}" "${fields[i+2]}" "${fields[i+4]}" session 2>&1); then
                    feedback="Open failed: $action_output"
                fi ;;
            ctrl-b)
                if tmux display-popup -E -w 80% -h 70% -d "$HOME/Projects" \
                    "zsh ${(q)WM_SELF} __action checkout ${(q)fields[i]} ${(q)fields[i+3]}"; then
                    refresh=1; force=1
                fi ;;
            ctrl-r)
                if tmux display-popup -E -w 70% -h 40% -d "$HOME/Projects" \
                    "zsh ${(q)WM_SELF} __action rename ${(q)fields[i]} ${(q)fields[i+3]}"; then
                    refresh=1; force=1
                fi ;;
            ctrl-d)
                manager_mutation ctrl-d "${fields[i]}" "${fields[i+3]}" || true ;;
        esac
    done
    if [[ -n "${TMUX:-}" ]]; then
        return_window=$(tmux show-window-options -v @worktree-manager-return 2>/dev/null) || return_window="${WM_RETURN_WINDOW:-}"
        [[ -n "$return_window" ]] && tmux select-window -t "$return_window" 2>/dev/null
    fi
    return 0
}

if [[ "$ZSH_EVAL_CONTEXT" == toplevel ]]; then
    case "${1:-}" in
        --launch) manager_launch ;;
        __create) worktree_create_picker ;;
        __action) shift; worktree_popup "$@" ;;
        __remove) shift; worktree_remove_job "$@" ;;
        __remove-action) shift; worktree_remove_action "$@" ;;
        __notice) shift; worktree_notice "$@" ;;
        __discover) shift; discover_worktrees "$@" ;;
        '') manager_main ;;
        --projects-root)
            [[ $# == 2 ]] || { print -u2 'Usage: worktree-manager.sh [--projects-root path]'; exit 2; }
            manager_main "$2" ;;
        *) print -u2 'Usage: worktree-manager.sh [--projects-root path]'; exit 2 ;;
    esac
fi
