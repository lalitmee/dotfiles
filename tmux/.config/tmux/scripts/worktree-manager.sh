#!/usr/bin/env zsh

source "${${(%):-%x}:A:h}/lib/worktree-manager/discovery.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/actions.zsh"
source "${${(%):-%x}:A:h}/lib/worktree-manager/popup.zsh"

# Absolute path to this script, reused when the picker opens a popup that
# re-invokes us through the __action subcommand.
typeset -g WM_SELF="${${(%):-%x}:A}"

# EPOCHSECONDS and zstat back the discovery cache freshness check.
zmodload zsh/datetime zsh/stat 2>/dev/null

# Escape control characters for single-line display; original fields stay in arrays.
manager_display() { print -rn -- "${(V)1}"; }

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
    print -u2 -r -- "$diagnostic"
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
    print -u2 -r -- "$feedback"
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
    (( ${#rows} )) || { feedback='No available branches.'; print -u2 -r -- "$feedback"; return 1; }
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
    local projects_root="$1" field output key id header refresh=1 force=0 return_window feedback='' action_output diagnostics picker_status filter=all show_main=0
    local -a fields rows choice
    while true; do
        if (( refresh )); then
            fields=(); rows=()
            # Cache the raw NUL records (they back the actions too). Version the
            # filename so a record-format change never reads a stale cache.
            # ponytail: key is the sanitized projects root and TTL caps staleness
            # at WM_CACHE_TTL (default 90s); ctrl-f and post-action refresh
            # always rescan, and actions re-validate before touching anything.
            local cache_file="${TMPDIR:-/tmp}/worktree-manager-cache.v6.${projects_root//[^A-Za-z0-9]/_}"
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
                        zsh -c 'zsh "$1" __discover "$2" > "$3" 2> "$4"' \
                        _ "$WM_SELF" "$projects_root" "$cache_tmp" "$diagnostics"
                else
                    print -r -- "Scanning worktrees under $projects_root... (this can take a while)"
                    discover_worktrees "$projects_root" 2> "$diagnostics" > "$cache_tmp"
                fi
                [[ -s "$diagnostics" ]] && feedback="$(< "$diagnostics")"
                rm -f -- "$diagnostics"
                while IFS= read -r -d '' field; do fields+=("$field"); done < "$cache_tmp"
                mv -f -- "$cache_tmp" "$cache_file" 2>/dev/null || rm -f -- "$cache_tmp"
            fi
            rows=()
            local i display
            for ((i=1; i+5<=${#fields}; i+=6)); do
                local group="${fields[i+1]}"
                if [[ "$filter" != all ]]; then
                    [[ "${group:l}" == "${filter:l}" ]] || continue
                fi
                (( show_main )) || [[ ",${fields[i+5]}," != *,main,* ]] || continue
                printf -v display '%-20.20s %-32.32s %s' \
                    "$(manager_display "${fields[i+2]}")" \
                    "$(manager_display "${fields[i+4]:-detached}")" \
                    "$(manager_display "${fields[i+3]}")"
                rows+=("$i"$'\t'"$display")
            done
            # Parallel discovery returns records in nondeterministic order; sort
            # rows (the id is the first tab field, so selections still map) for a
            # stable listing across runs.
            (( ${#rows} )) && rows=("${(@f)$(printf '%s\n' "${rows[@]}" | LC_ALL=C sort -t$'\t' -k2,2)}")
            refresh=0; force=0
        fi
        local filter_label="$filter"
        local main_label=off
        (( show_main )) && main_label=on
        header="enter open | ctrl-b checkout | ctrl-r rename | ctrl-d remove | ctrl-g filter:${filter_label} | ctrl-t mains:${main_label} | ctrl-f refresh | esc quit"
        if (( ${#rows} == 0 )); then
            header="No worktrees found under $projects_root (filter: ${filter_label}). ctrl-g toggle filter | ctrl-t mains:${main_label} | ctrl-f refresh | esc quit"
        fi
        [[ -n "$feedback" ]] && header+=$'\n'"$feedback"
        picker_status=0
        output=$({
            printf '%s\n' $'0\tREPOSITORY           BRANCH                           PATH'
            (( ${#rows} )) && printf '%s\n' "${rows[@]}"
        } | fzf --delimiter=$'\t' --with-nth=2.. --header-lines=1 --expect=enter,ctrl-b,ctrl-r,ctrl-d,ctrl-g,ctrl-t,ctrl-f --bind=esc:abort,ctrl-c:abort --header="$header" --no-multi) || picker_status=$?
        choice=("${(@f)output}"); key="${choice[1]:-}"
        # An expected refresh key can accompany status 1 when no result matches.
        if [[ "$key" == ctrl-f ]] && (( picker_status == 0 || picker_status == 1 )); then
            refresh=1; force=1
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
        [[ "$key" == enter || "$key" == ctrl-b || "$key" == ctrl-r || "$key" == ctrl-d ]] || continue
        id="${${choice[2]:-}%%$'\t'*}"
        [[ "$id" == <-> ]] && (( id>=1 && id<=${#fields} )) || continue
        i=$id
        feedback=''
        # Prompts use the terminal directly; action diagnostics also appear in
        # the next fzf header so refreshing the screen does not hide the error.
        case "$key" in
            enter)
                if action_output=$(open_worktree "${fields[i+3]}" "${fields[i+2]}" "${fields[i+4]}" 2>&1); then
                    feedback='Opened worktree.'
                else
                    feedback="Open failed: $action_output"
                fi ;;
            ctrl-b)
                if tmux display-popup -E -w 80% -h 70% -d "$HOME/Projects" \
                    "zsh ${(q)WM_SELF} __action checkout ${(q)fields[i]} ${(q)fields[i+3]}"; then
                    refresh=1; force=1; feedback='Checkout completed.'
                else
                    [[ -n "$feedback" ]] || feedback='Checkout cancelled or failed.'
                fi ;;
            ctrl-r)
                if tmux display-popup -E -w 70% -h 40% -d "$HOME/Projects" \
                    "zsh ${(q)WM_SELF} __action rename ${(q)fields[i]} ${(q)fields[i+3]}"; then
                    refresh=1; force=1; feedback='Worktree renamed.'
                else
                    [[ -n "$feedback" ]] || feedback='Rename cancelled or failed.'
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
        __action) shift; worktree_popup "$@" ;;
        __remove) shift; worktree_remove_job "$@" ;;
        __remove-action) shift; worktree_remove_action "$@" ;;
        __discover) shift; discover_worktrees "$@" ;;
        '') manager_main "$HOME/Projects" ;;
        --projects-root)
            [[ $# == 2 ]] || { print -u2 'Usage: worktree-manager.sh [--projects-root path]'; exit 2; }
            manager_main "$2" ;;
        *) print -u2 'Usage: worktree-manager.sh [--projects-root path]'; exit 2 ;;
    esac
fi
