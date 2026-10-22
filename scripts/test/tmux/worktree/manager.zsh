#!/usr/bin/env zsh

set -euo pipefail
SCRIPT_DIR="${0:A:h}"
WORKSPACE_DIR="${SCRIPT_DIR:h:h:h:h}"
DISCOVERY="$WORKSPACE_DIR/tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh"
CONFIG="$WORKSPACE_DIR/tmux/.config/tmux/scripts/lib/worktree-manager/config.zsh"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

fail() { print -u2 -- "FAIL: $*"; exit 1; }
assert_equal() { [[ "$1" == "$2" ]] || fail "$3: expected [$2], got [$1]"; }

test_discovery() {
    [[ -f "$DISCOVERY" ]] || fail "discovery library is missing"
    source "$DISCOVERY"
    local projects="$TEST_DIR/Projects" personal="$TEST_DIR/Projects/Personal/project one"
    local work="$TEST_DIR/Projects/Work/project two" external="$TEST_DIR/external tree"
    local nested="$personal/nested tree" early="$TEST_DIR/Projects/Personal/early/linked tree" field
    local separate="$projects/Work/separate project" separate_link="${early:h}/separate link"
    local additional="$TEST_DIR/extra repositories" extra extra_link="$TEST_DIR/extra linked"
    extra="$additional/project with spaces"
    local storage="$TEST_DIR/custom Git storage"
    local -a fields
    local -A path_counts
    # Creation order makes traversal see a linked candidate before its main root.
    mkdir -p "${early:h}" "$personal" "$work"
    git init -q -b main "$personal"
    git -C "$personal" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    git init -q -b main "$work"
    git -C "$work" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    git -C "$personal" worktree add -q -b external "$external"
    git -C "$personal" worktree add -q -b nested "$nested"
    git -C "$personal" worktree add -q -b early "$early"
    git init -q -b main --separate-git-dir="$storage" "$separate"
    git -C "$separate" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    git -C "$separate" worktree add -q -b separate-link "$separate_link"
    mkdir -p "$projects/Work/broken/.git" "$projects/node_modules/ignored"
    git init -q -b main "$projects/node_modules/ignored"
    discover_worktrees "$projects" > "$TEST_DIR/inventory" 2> "$TEST_DIR/errors"
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$TEST_DIR/inventory"
    assert_equal "${#fields}" 42 "deduplicated seven worktrees"
    local i expected_path
    for ((i=1; i<=${#fields}; i+=6)); do
        path_counts[${fields[i+3]}]=$(( ${path_counts[${fields[i+3]}]:-0} + 1 ))
        case "${fields[i+3]}" in
            "$personal") assert_equal "${fields[i+5]}" main "personal main flag" ;;
            "$external")
                assert_equal "${fields[i]}" "$personal" "external owner"
                assert_equal "${fields[i+1]}" Personal "external group"
                assert_equal "${fields[i+2]}" 'project one' "external name"
                assert_equal "${fields[i+4]}" external "external branch" ;;
            "$nested") [[ "${fields[i+5]}" != *main* ]] || fail "linked worktree marked main" ;;
            "$early")
                assert_equal "${fields[i]}" "$personal" "early linked owner"
                [[ "${fields[i+5]}" != *main* ]] || fail "early linked worktree marked main" ;;
            "$work") assert_equal "${fields[i+1]}" Work "work group" ;;
            "$separate"|"$separate_link")
                assert_equal "${fields[i]}" "$separate" "custom Git directory owning root"
                assert_equal "${fields[i+1]}" Work "custom Git directory group"
                assert_equal "${fields[i+2]}" 'separate project' "custom Git directory name"
                if [[ "${fields[i+3]}" == "$separate" ]]; then
                    assert_equal "${fields[i+5]}" main "custom Git directory main flag"
                else
                    [[ "${fields[i+5]}" != *main* ]] || fail "separate linked worktree marked main"
                fi ;;
            *) fail "unexpected worktree ${fields[i+3]}" ;;
        esac
    done
    for expected_path in "$personal" "$work" "$external" "$nested" "$early" "$separate" "$separate_link"; do
        assert_equal "${path_counts[$expected_path]:-0}" 1 "expected path appears exactly once: $expected_path"
    done
    mkdir -p "$additional"
    git init -q -b main "$extra"
    git -C "$extra" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    git -C "$extra" worktree add -q -b extra-link "$extra_link"
    fields=(); path_counts=()
    discover_worktrees "$projects" "$projects/Personal" "$additional" > "$TEST_DIR/multi-root" 2> "$TEST_DIR/multi-errors"
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$TEST_DIR/multi-root"
    assert_equal "${#fields}" 54 'overlapping multi-root scan keeps nine unique worktrees in six-field records'
    for ((i=1; i<=${#fields}; i+=6)); do
        path_counts[${fields[i+3]}]=$(( ${path_counts[${fields[i+3]}]:-0} + 1 ))
    done
    for expected_path in "$personal" "$work" "$external" "$nested" "$early" "$separate" "$separate_link" "$extra" "$extra_link"; do
        assert_equal "${path_counts[$expected_path]:-0}" 1 "multi-root path appears exactly once: $expected_path"
    done
    [[ ! -s "$TEST_DIR/errors" ]] || fail "invalid .git candidate warning was not suppressed"
    assert_equal "$(worktree_status "$external")" clean "clean state"
    print dirty > "$external/untracked"
    assert_equal "$(worktree_status "$external")" dirty "untracked state"
    assert_equal "$(worktree_status "$TEST_DIR/missing")" missing "missing state"
    assert_equal "$(worktree_status "$TEST_DIR")" unknown "non-repository state"
    local stale="$personal/stale directory"
    mkdir -p "$stale"
    assert_equal "$(worktree_status "$stale")" unknown "nested stale directory must not inherit parent status"

    # Literal NUL fixtures catch whitespace splitting and malformed record leakage.
    printf '%s\0' "worktree $personal" 'HEAD 012345' 'branch refs/heads/main' '' \
        "worktree $external" 'HEAD 012345' detached 'locked reason with spaces' '' \
        "worktree $TEST_DIR/missing tree" 'HEAD 012345' 'branch refs/heads/stale' 'prunable gone' '' \
        "worktree $TEST_DIR/bare repo" bare '' \
        "worktree $TEST_DIR/incomplete" 'HEAD 012345' '' \
        'HEAD 012345' 'branch refs/heads/orphan' '' \
        "worktree $stale" 'HEAD 012345' 'branch refs/heads/stale' '' > "$TEST_DIR/porcelain"
    fields=()
    parse_worktree_porcelain "$personal" "$TEST_DIR/porcelain" > "$TEST_DIR/parsed" 2> "$TEST_DIR/parser-errors"
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$TEST_DIR/parsed"
    assert_equal "${#fields}" 30 "malformed records skipped and later valid records retained"
    assert_equal "${fields[11]}" '' "detached branch"
    assert_equal "${fields[12]}" 'detached,locked' "detached locked flags"
    assert_equal "${fields[18]}" prunable "prunable flag"
    assert_equal "${fields[24]}" bare "bare flag"
    assert_equal "${fields[30]}" '' "stale nested directory must not be main"
    [[ -s "$TEST_DIR/parser-errors" ]] || fail "malformed parser error not reported"
    [[ "$(<"$TEST_DIR/parser-errors")" == *"$personal"* ]] || fail "parser error lacks repository"
    : > "$TEST_DIR/empty"
    parse_worktree_porcelain "$personal" "$TEST_DIR/empty" > "$TEST_DIR/parsed"
    [[ ! -s "$TEST_DIR/parsed" ]] || fail "empty porcelain emitted rows"
    printf '%s\0' "worktree $personal" 'HEAD 012345' 'branch refs/heads/main' > "$TEST_DIR/incomplete"
    parse_worktree_porcelain "$personal" "$TEST_DIR/incomplete" > "$TEST_DIR/parsed" 2> "$TEST_DIR/parser-errors"
    [[ ! -s "$TEST_DIR/parsed" && -s "$TEST_DIR/parser-errors" ]] || fail "unterminated record accepted"
    print 'PASS: global worktree discovery'
}

test_config() {
    [[ -f "$CONFIG" ]] || fail 'config library is missing'
    source "$CONFIG"
    local HOME="$TEST_DIR/home" XDG_CONFIG_HOME="$TEST_DIR/xdg" field expected config
    local tracked_config="$WORKSPACE_DIR/tmux/.config/worktree-manager/roots"
    local -a roots
    mkdir -p "$HOME/Projects" "$HOME/relative root" "$TEST_DIR/xdg/absolute root"
    [[ -f "$tracked_config" ]] || fail 'tracked worktree roots config is missing'
    grep -Fxq '~/Projects' "$tracked_config" || fail 'tracked config omits Projects root'
    grep -Fxq '~/dotfiles' "$tracked_config" || fail 'tracked config omits dotfiles root'
    config="$XDG_CONFIG_HOME/worktree-manager/roots"
    assert_equal "$(worktree_manager_config_path)" "$config" 'XDG config path'
    local XDG_CONFIG_HOME=''
    assert_equal "$(worktree_manager_config_path)" "$HOME/.config/worktree-manager/roots" 'default config path'
    local XDG_CONFIG_HOME="$TEST_DIR/xdg"
    load_worktree_roots > "$TEST_DIR/roots"
    roots=(); while IFS= read -r -d '' field; do roots+=("$field"); done < "$TEST_DIR/roots"
    assert_equal "${#roots}" 1 'missing config default count'
    assert_equal "${roots[1]}" "${HOME}/Projects" 'missing config default root'
    mkdir -p "${config:h}"
    : > "$config"
    load_worktree_roots > "$TEST_DIR/roots"
    [[ ! -s "$TEST_DIR/roots" ]] || fail 'empty config unexpectedly restores default root'
    cat > "$config" <<EOF
# comment

~/Projects
relative root
$TEST_DIR/xdg/absolute root
~/Projects/../Projects
$WORKSPACE_DIR
missing root
EOF
    load_worktree_roots > "$TEST_DIR/roots" 2> "$TEST_DIR/root-errors"
    roots=(); while IFS= read -r -d '' field; do roots+=("$field"); done < "$TEST_DIR/roots"
    assert_equal "${#roots}" 4 'configured root count and canonical duplicate removal'
    assert_equal "${roots[1]}" "${HOME}/Projects" 'tilde expansion'
    assert_equal "${roots[2]}" "${HOME}/relative root" 'relative root resolves from home'
    assert_equal "${roots[3]}" "$TEST_DIR/xdg/absolute root" 'space-containing absolute root'
    assert_equal "${roots[4]}" "$WORKSPACE_DIR" 'absolute dotfiles root'
    [[ "$(<"$TEST_DIR/root-errors")" == *'missing root'* ]] || fail 'missing root diagnostic absent'

    local manager="$WORKSPACE_DIR/tmux/.config/tmux/scripts/worktree-manager.sh"
    source "$manager"
    _worktree_popup_gum() { return 1; }
    local calls="$TEST_DIR/config-discovery-calls"
    discover_worktrees() {
        printf '%s\0' "$@" > "$calls"
        printf '%s\0' "$TEST_DIR/repo" Personal repo "$TEST_DIR/repo" main main
    }
    fzf() { cat >/dev/null; return 130; }
    tmux() { return 0; }
    local TMUX=''
    manager_main > /dev/null
    roots=(); while IFS= read -r -d '' field; do roots+=("$field"); done < "$calls"
    assert_equal "${#roots}" 4 'manager startup passes all configured roots'
    assert_equal "${(j:|:)roots}" "${HOME}/Projects|${HOME}/relative root|$TEST_DIR/xdg/absolute root|$WORKSPACE_DIR" 'manager root argument boundaries'
    unfunction discover_worktrees fzf tmux
    print 'PASS: global worktree config'
}

test_actions() {
    local actions="$WORKSPACE_DIR/tmux/.config/tmux/scripts/lib/worktree-manager/actions.zsh"
    [[ -f "$actions" ]] || fail "actions library is missing"
    source "$DISCOVERY"
    source "$actions"
    local repo="$TEST_DIR/action repo" linked="$TEST_DIR/linked tree" moved="$TEST_DIR/moved tree"
    local field joined
    local -a fields
    mkdir -p "$repo"
    command git init -q -b main "$repo"
    command git -C "$repo" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    command git -C "$repo" worktree add -q -b topic "$linked"
    command git -C "$repo" branch available
    command git -C "$repo" update-ref refs/remotes/origin/remote-only HEAD
    command git -C "$repo" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/remote-only
    command git -C "$repo" config remote.origin.url "$repo"
    command git -C "$repo" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    # Log exact NUL-delimited arguments, while real Git exercises registry safety.
    local git_log="$TEST_DIR/git-log" tmux_log="$TEST_DIR/tmux-log"
    local open_sessions='' open_panes=''
    git() { printf '%s\0' "$@" >> "$git_log"; command git "$@"; }
    tmux() {
        printf '%s\0' "$@" >> "$tmux_log"
        case "$1" in
            list-sessions) [[ -z "$open_sessions" ]] || print -r -- "$open_sessions" ;;
            list-panes) [[ -z "$open_panes" ]] || print -r -- "$open_panes" ;;
            list-windows)
                if [[ "$2" == -t ]]; then
                    print -r -- '@window-first'
                    print -r -- '@window-second'
                else
                    print -r -- 'project:topic'
                    print -r -- 'project:topic-2'
                fi ;;
        esac
    }
    list_repository_branches "$repo" > "$TEST_DIR/branches"
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$TEST_DIR/branches"
    assert_equal "${#fields}" 16 'local and remote inventory'
    local i
    for (( i=1; i<=${#fields}; i+=4 )); do
        if [[ "${fields[i]}" == refs/heads/topic ]]; then
            assert_equal "${fields[i+3]}" "$linked" 'occupied branch path'
        fi
    done
    checkout_branch "$repo" "$linked" refs/heads/main 0 2>/dev/null && fail 'occupied checkout allowed'
    checkout_branch "$repo" "$linked" refs/remotes/origin/remote-only 0 2>/dev/null && fail 'unconfirmed tracking creation'
    checkout_branch "$repo" "$linked" refs/heads/available 0
    assert_equal "$(command git -C "$linked" branch --show-current)" available 'local switch'
    checkout_branch "$repo" "$linked" refs/remotes/origin/remote-only 1
    assert_equal "$(command git -C "$linked" branch --show-current)" remote-only 'remote tracking switch'
    rename_worktree "$repo" "$repo" "$moved" 2>/dev/null && fail 'main move allowed'
    rename_worktree "$repo" "$linked" "$repo" 2>/dev/null && fail 'existing destination allowed'
    remove_worktree "$repo" "$repo" 1 2>/dev/null && fail 'main removal allowed'
    print dirty > "$linked/untracked"
    remove_worktree "$repo" "$linked" 0 2>/dev/null && fail 'dirty normal removal allowed'
    remove_worktree "$repo" "$linked" yes 2>/dev/null && fail 'invalid force token allowed'
    # A registered nested directory with missing metadata must not inherit its ancestor.
    local stale="$repo/stale tree"
    command git -C "$repo" worktree add -q -b stale "$stale"
    rm -- "$stale/.git"
    checkout_branch "$repo" "$stale" refs/heads/topic 0 2>/dev/null && fail 'ancestor checkout allowed'
    rename_worktree "$repo" "$stale" "$TEST_DIR/stale moved" 2>/dev/null && fail 'ancestor move allowed'
    remove_worktree "$repo" "$stale" 1 2>/dev/null && fail 'unknown force removal allowed'
    rename_worktree "$repo" "$linked" "$moved"
    assert_equal "$(command git -C "$moved" branch --show-current)" remote-only 'move preserves branch'
    open_worktree "$moved" project topic
    fields=()
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$tmux_log"
    joined="${(j:|:)fields}"
    [[ "$joined" == *'new-window|-n|project:topic-3|-c|'"$moved" ]] || \
        fail 'collision-safe window arguments'
    : > "$tmux_log"
    open_sessions=$'@session\t'"$moved"
    open_worktree "$moved" project topic
    fields=(); while IFS= read -r -d '' field; do fields+=("$field"); done < "$tmux_log"
    joined="${(j:|:)fields}"
    [[ "$joined" == *'switch-client|-t|@session|select-window|-t|@session:@window-first' ]] || \
        fail 'worktree session does not select its first window'
    [[ "$joined" != *new-window* ]] || fail 'worktree session opens a duplicate window'
    : > "$tmux_log"
    open_sessions=''
    open_panes=$'@other-session\t@other-window\t'"$moved"
    open_worktree "$moved" project topic
    fields=(); while IFS= read -r -d '' field; do fields+=("$field"); done < "$tmux_log"
    joined="${(j:|:)fields}"
    [[ "$joined" == *'select-window|-t|@other-session:@other-window' ]] || \
        fail 'existing worktree window is not selected'
    [[ "$joined" != *new-window* ]] || fail 'existing worktree window is duplicated'
    : > "$tmux_log"
    # An existing window/pane must not intercept session mode.
    open_panes=$'@other-session\t@other-window\t'"$moved"
    open_worktree "$moved" project topic session
    fields=(); while IFS= read -r -d '' field; do fields+=("$field"); done < "$tmux_log"
    joined="${(j:|:)fields}"
    [[ "$joined" == *'new-session|-c|'"$moved"'|-d|-s|project-topic|switch-client|-t|project-topic'* ]] || \
        fail 'session key does not create and switch to a session'
    [[ "$joined" != *new-window* ]] || fail 'session key creates a window instead of a session'
    remove_worktree "$repo" "$moved" 1
    command git -C "$repo" show-ref --verify --quiet refs/heads/remote-only || fail 'worktree removal deleted branch'
    # Confirm successful mutations have explicit context and no force checkout.
    fields=()
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$git_log"
    joined="${(j:|:)fields}"
    [[ "$joined" == *"-C|$linked|switch|--|available"* ]] || fail 'local switch arguments'
    [[ "$joined" == *"-C|$linked|switch|--track|-c|remote-only|--|origin/remote-only"* ]] || fail 'tracking switch arguments'
    [[ "$joined" == *"-C|$repo|worktree|move|--|$linked|$moved"* ]] || fail 'worktree move arguments'
    [[ "$joined" == *"-C|$repo|worktree|remove|--force|--|$moved"* ]] || fail 'force remove arguments'
    [[ "$joined" != *'|branch|'* && "$joined" != *'switch|--force'* ]] || fail 'branch deletion or forced checkout'
    local clean_tree="$TEST_DIR/clean tree" foreign="$TEST_DIR/foreign repo"
    command git -C "$repo" worktree add -q -b clean-remove "$clean_tree"
    remove_worktree "$repo" "$clean_tree" 0
    [[ ! -e "$clean_tree" ]] || fail 'normal clean removal failed'
    command git -C "$repo" show-ref --verify --quiet refs/heads/clean-remove || fail 'normal removal deleted branch'
    checkout_branch "$repo" "$clean_tree" refs/heads/topic 0 2>/dev/null && fail 'missing checkout allowed'
    remove_worktree "$repo" "$clean_tree" 1 2>/dev/null && fail 'missing removal allowed'
    command git init -q -b main "$foreign"
    command git -C "$foreign" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    checkout_branch "$repo" "$foreign" refs/heads/topic 0 2>/dev/null && fail 'foreign repository checkout allowed'
    rename_worktree "$repo" "$foreign" "$TEST_DIR/foreign moved" 2>/dev/null && fail 'foreign repository move allowed'
    remove_worktree "$repo" "$foreign" 1 2>/dev/null && fail 'foreign repository removal allowed'
    fields=()
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$git_log"
    local switches=0 moves=0 removes=0
    for ((i=1; i<=${#fields}; i++)); do
        case "${fields[i]}" in
            switch)
                [[ "${fields[i-2]}" == -C ]] || fail 'switch lacks explicit context'
                (( switches+=1 )) ;;
            move)
                [[ "${fields[i-3]}" == -C && "${fields[i-2]}" == "$repo" ]] || fail 'move lacks owning context'
                (( moves+=1 )) ;;
            remove)
                [[ "${fields[i-3]}" == -C && "${fields[i-2]}" == "$repo" ]] || fail 'remove lacks owning context'
                (( removes+=1 )) ;;
        esac
    done
    assert_equal "$switches" 2 'only authorized checkout mutations ran'
    assert_equal "$moves" 1 'only authorized move ran'
    assert_equal "$removes" 2 'only authorized removals ran'
    local separate="$TEST_DIR/separate checkout" storage="$TEST_DIR/separate storage"
    local separate_link="$TEST_DIR/separate linked"
    command git init -q -b main --separate-git-dir="$storage" "$separate"
    command git -C "$separate" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    command git -C "$separate" worktree add -q -b linked "$separate_link"
    fields=()
    list_repository_branches "$separate" > "$TEST_DIR/separate-branches"
    while IFS= read -r -d '' field; do fields+=("$field"); done < "$TEST_DIR/separate-branches"
    local main_occupancy=''
    for ((i=1; i<=${#fields}; i+=4)); do
        [[ "${fields[i]}" == refs/heads/main ]] && main_occupancy="${fields[i+3]}"
    done
    assert_equal "$main_occupancy" "$separate" 'separate Git directory main occupancy uses checkout root'
    checkout_branch "$separate" "$separate_link" refs/heads/main 0 2>/dev/null && fail 'separate main occupied checkout allowed'
    unfunction git tmux
    print 'PASS: global worktree actions'
}

test_interface() {
    local manager="$WORKSPACE_DIR/tmux/.config/tmux/scripts/worktree-manager.sh"
    [[ -f "$manager" ]] || fail 'manager interface is missing'
    source "$manager"
    local COLUMNS=40 wrapped_header plain_header header_line
    local -a header_lines
    [[ -n "${functions[worktree_manager_header]:-}" ]] || fail 'worktree manager header formatter is missing'
    wrapped_header=$(worktree_manager_header)
    plain_header="$(print -r -- "$wrapped_header" | sed -E $'s/\033\\[[0-9;]*m//g')"
    header_lines=("${(@f)plain_header}")
    (( ${#header_lines} > 1 )) || fail 'narrow header is not wrapped'
    for header_line in "${header_lines[@]}"; do
        (( ${#header_line} <= COLUMNS )) || fail "wrapped header line exceeds terminal width: $header_line"
    done
    for header_line in 'enter: open window' 'ctrl-s: open session' 'ctrl-b: checkout' 'ctrl-r: rename' 'ctrl-d: remove' 'ctrl-g: filter:all' 'ctrl-t: mains:off' 'ctrl-f: refresh' 'ctrl-o: create worktree' 'esc: quit'; do
        [[ "$plain_header" == *"$header_line"* ]] || fail "wrapped header omits keybinding: $header_line"
    done
    local original_manager_checkout="${functions[manager_checkout]}"
    local selected_path="$TEST_DIR/tree with spaces" ui_status=clean ui_flags='' ui_add_main=0 ui_add_prunable=0 ui_warning=''
    local ui_dir="$TEST_DIR/ui" result
    local cache_id; cache_id=$(printf '%s\0' "$TEST_DIR/Projects" | cksum)
    cache_id="${cache_id%% *}"
    local cache_file="${TMPDIR:-/tmp}/worktree-manager-cache.v7.${cache_id}"
    mkdir -p "$ui_dir"
    local style_args="$ui_dir/style-args" style_joined
    local popup_gum_original="${functions[_worktree_popup_gum]}"
    local COLUMNS=100 LINES=30
    local -a calls create_args
    _worktree_popup_gum() { return 0; }
    gum() { print -rl -- "$@" >> "$style_args"; }
    print -n x | worktree_notice info 'center me' > /dev/null
    style_joined="$(< "$style_args")"
    [[ "$style_joined" == *$'--width\n100'* ]] || fail 'notice frame does not fill popup width'
    [[ "$style_joined" == *$'--height\n29'* ]] || fail 'notice frame does not leave room for key prompt'
    [[ "$style_joined" == *$'--align\ncenter'* ]] || fail 'notice text is not centered'
    [[ "$style_joined" == *$'\n\ncenter me'* ]] || fail 'notice text is not vertically centered'
    [[ "$style_joined" == *$'--border\nrounded'* ]] || fail 'notice border style changed'
    unfunction gum
    _worktree_popup_gum() { return 1; }
    discover_worktrees() {
        print x >> "$ui_dir/scans"
        [[ -z "$ui_warning" ]] || print -u2 -r -- "$ui_warning"
        [[ -f "$ui_dir/empty" ]] && return 0
        printf '%s\0' "$TEST_DIR/repo" Personal 'project name' "$selected_path" topic ''
        if (( ui_add_main )); then
            printf '%s\0' "$TEST_DIR/repo" Personal 'main project' "$TEST_DIR/main tree" main main
        fi
        if (( ui_add_prunable )); then
            printf '%s\0' "$TEST_DIR/repo" Personal 'stale project' "$TEST_DIR/stale tree" topic prunable
        fi
    }
    _worktree_manager_validate() { wm_action_status="$ui_status"; wm_action_flags="$ui_flags"; }
    list_repository_branches() {
        printf '%s\0' refs/heads/other local other '' refs/heads/busy local busy "$TEST_DIR/other tree" refs/remotes/origin/remote remote origin/remote ''
    }
    open_worktree() { printf '%s\0' open "$@" >> "$ui_dir/actions"; }
    checkout_branch() { printf '%s\0' checkout "$@" >> "$ui_dir/actions"; }
    rename_worktree() { printf '%s\0' rename "$@" >> "$ui_dir/actions"; }
    remove_worktree() { printf '%s\0' remove "$@" >> "$ui_dir/actions"; }
    fzf() {
        local count=$(cat "$ui_dir/count")
        cat > "$ui_dir/rows.$count"
        print -r -- "$*" > "$ui_dir/options.$count"
        print $((count+1)) > "$ui_dir/count"
        [[ -f "$ui_dir/reply.$count" ]] || return 130
        cat "$ui_dir/reply.$count"
        [[ ! -f "$ui_dir/status.$count" ]] || return "$(cat "$ui_dir/status.$count")"
        return 0
    }
    tmux() {
        local -a args
        args=("$@")
        printf '%s\0' "$@" >> "$ui_dir/tmux"
        case "$1" in
            display-popup)
                case "${args[-1]}" in
                    *'__action checkout '*) worktree_popup checkout "$TEST_DIR/repo" "$selected_path"; return $? ;;
                    *'__action rename '*) worktree_popup rename "$TEST_DIR/repo" "$selected_path"; return $? ;;
                esac ;;
            display-message) print '@9' ;;
            list-windows) [[ ! -f "$ui_dir/existing" ]] || printf '@7\tworktree-manager\n' ;;
            show-window-options) print '@9' ;;
        esac
        return 0
    }
    ui_reset() {
        rm -f -- "$ui_dir"/*(N)
        rm -f -- "$cache_file"
        print 1 > "$ui_dir/count"
    }
    ui_reset
    ui_add_main=1
    printf 'ctrl-o\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ "$(cat "$ui_dir/options.1")" == *'--expect=enter,ctrl-s,ctrl-b,ctrl-r,ctrl-d,ctrl-g,ctrl-t,ctrl-f,ctrl-o'* ]] || fail 'create key is absent from fzf expect list'
    [[ "$(cat "$ui_dir/options.1")" == *'ctrl-o'*'create worktree'* ]] || fail 'create key is absent from manager header'
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    local new_windows=0
    for field in "${calls[@]}"; do [[ "$field" == new-window ]] && (( new_windows += 1 )); done
    assert_equal "$new_windows" 1 'create action launches one dedicated window'
    [[ "${(j:|:)calls}" == *'new-window|-n|worktree-create|-c|'*'__create'* ]] || fail 'create action does not launch the dedicated picker'

    local repo_one="$TEST_DIR/repo ; literal" repo_two="$TEST_DIR/second repo" linked="$TEST_DIR/linked repo"
    local create_script="$TEST_DIR/fake-create.zsh" create_log="$TEST_DIR/create-log" picker_rows="$TEST_DIR/create-rows" picker_no_main=0
    local original_create_fzf="${functions[fzf]}" original_create_discovery="${functions[discover_worktrees]}"
    mkdir -p "$repo_one" "$repo_two"
    command git init -q -b main "$repo_one"
    command git -C "$repo_one" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    command git -C "$repo_one" worktree add -q -b linked "$linked"
    command git init -q -b main "$repo_two"
    command git -C "$repo_two" -c user.name=Test -c user.email=test@example.invalid commit -qm initial --allow-empty
    cat > "$create_script" <<'EOF'
#!/usr/bin/env zsh
printf '%s\0' "$PWD" "$@" > "$WM_CREATE_LOG"
EOF
    chmod +x "$create_script"
    export WM_CREATE_LOG="$create_log"
    local WORKTREE_MANAGER_CREATE_SCRIPT="$create_script"
    local picker_call_count_file="$TEST_DIR/picker-count"
    print 0 > "$picker_call_count_file"
    fzf() {
        cat > "$picker_rows"
        print -r -- "$*" > "$ui_dir/create-options"
        local picker_call_count=$(<"$picker_call_count_file")
        (( picker_call_count += 1 ))
        print "$picker_call_count" > "$picker_call_count_file"
        case "$picker_call_count" in
            1) print -r -- $'1\tforged shell text' ;;
            2) return 130 ;;
            3) print -r -- $'99\tinvalid record forged' ;;
        esac
    }
    discover_worktrees() {
        if (( picker_no_main )); then
            printf '%s\0' "$repo_one" Personal one "$linked" linked ''
            return 0
        fi
        printf '%s\0' "$repo_one" Personal 'first' "$repo_one" main main \
            "$repo_one" Personal one "$linked" linked '' \
            "$repo_two" Work 'second repository with a longer name' "$repo_two" main main
    }
    (worktree_create_picker "$TEST_DIR/root one" "$TEST_DIR/root two")
    [[ "$(cat "$picker_rows")" == *"$repo_one"* && "$(cat "$picker_rows")" == *"$repo_two"* ]] || fail 'picker misses main worktrees from configured roots'
    [[ "$(cat "$picker_rows")" != *"$linked"* ]] || fail 'picker includes a linked worktree'
    local first_path_column second_path_column
    first_path_column=$(awk -v path="$repo_one" 'NR == 1 { print index($0, path) }' "$picker_rows")
    second_path_column=$(awk -v path="$repo_two" 'NR == 2 { print index($0, path) }' "$picker_rows")
    assert_equal "$first_path_column" "$second_path_column" 'picker aligns repository paths after names'
    create_args=(); while IFS= read -r -d '' field; do create_args+=("$field"); done < "$create_log"
    assert_equal "${create_args[1]}" "$repo_one" 'selected repository cwd preserves spaces and shell characters'
    assert_equal "${create_args[2]}" create 'existing custom create flow receives one create argument'
    rm -f -- "$create_log"
    (worktree_create_picker "$TEST_DIR/root one")
    [[ ! -e "$create_log" ]] || fail 'picker cancellation launches creation'
    (worktree_create_picker "$TEST_DIR/root one")
    [[ ! -e "$create_log" ]] || fail 'non-main or out-of-range selection launches creation'
    picker_no_main=1
    (worktree_create_picker "$TEST_DIR/root one")
    [[ ! -e "$create_log" ]] || fail 'linked-only inventory launches creation'
    functions[fzf]="$original_create_fzf"
    functions[discover_worktrees]="$original_create_discovery"

    ui_reset
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    print 1 > "$ui_dir/status.2"
    printf 'yes\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    assert_equal "${calls[4]}" new-window 'removal launches a dedicated window'
    [[ "${calls[9]}" == *'__remove'*"$TEST_DIR/repo"*"$selected_path"*'0'*'@9'* ]] || fail 'worker command does not preserve removal arguments and manager target'
    [[ ! -f "$ui_dir/actions" ]] || fail 'manager removes worktree synchronously'
    ui_reset
    ui_add_main=1
    ui_add_prunable=1
    printf 'ctrl-t\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    print 1 > "$ui_dir/status.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ "$(cat "$ui_dir/output")" != *'Scanning worktrees'* ]] || fail 'scan progress leaked into picker output'
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 2 'main worktrees hidden by default'
    assert_equal "$(wc -l < "$ui_dir/rows.2" | tr -d ' ')" 3 'toggle shows main worktrees'
    [[ "$(cat "$ui_dir/rows.1" "$ui_dir/rows.2")" != *'stale project'* ]] || fail 'prunable worktree appears in picker'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[38;2;255;98;140mctrl-t:\e[0m \e[38;2;255;198;0mmains:off'* ]] || fail 'main-worktree toggle state is not shown'
    [[ "$(cat "$ui_dir/options.2")" == *$'\e[38;2;255;98;140mctrl-t:\e[0m \e[38;2;255;198;0mmains:on'* ]] || fail 'main-worktree toggle state did not update'
    [[ "$(cat "$ui_dir/options.1")" == *'--ansi'* ]] || fail 'picker does not enable ANSI colors'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[38;2;255;98;140mctrl-d:\e[0m'* ]] || fail 'keybinding color missing'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[0m \e[38;2;255;198;0mremove\e[0m'* ]] || fail 'keybinding description color missing'
    [[ "$(cat "$ui_dir/rows.1")" == *$'0\t\e[38;2;138;138;138mREPOSITORY'* ]] || fail 'column heading delimiter or color missing'
    local rows_content
    rows_content=$(cat "$ui_dir/rows.2")
    [[ "$rows_content" == *$'\e[1;38;2;255;198;0mmain project'* ]] || fail 'main worktree lacks expected Cobalt2 color'
    [[ "$rows_content" == *$'\e[1;38;2;255;198;0mproject name'* ]] || fail 'worktree from same repo lacks identical Cobalt2 color'
    local feedback='' popup_output
    manager_checkout() { return 0; }
    popup_output=$(worktree_popup checkout "$TEST_DIR/repo" "$selected_path" </dev/null)
    [[ "$popup_output" == *'SUCCESS: Checkout completed.'* ]] || fail 'checkout success notice missing'
    manager_checkout() { feedback='checkout failed with details'; return 1; }
    popup_output=$(worktree_popup checkout "$TEST_DIR/repo" "$selected_path" </dev/null) && fail 'failed checkout returned success'
    [[ "$popup_output" == *'ERROR: checkout failed with details'* ]] || fail 'checkout error detail missing'
    manager_checkout() { feedback='No available branches.'; return 1; }
    popup_output=$(worktree_popup checkout "$TEST_DIR/repo" "$selected_path" </dev/null) && fail 'empty checkout returned success'
    [[ "$popup_output" == *'INFO: No available branches.'* ]] || fail 'no-branches info notice missing'
    manager_checkout() { return 1; }
    feedback=''
    popup_output=$(worktree_popup checkout "$TEST_DIR/repo" "$selected_path" </dev/null) && fail 'cancelled checkout returned success'
    [[ "$popup_output" != *'Press any key'* ]] || fail 'checkout cancellation displayed a notice'
    functions[manager_checkout]="$original_manager_checkout"
    ui_add_main=0
    ui_add_prunable=0
    ui_reset
    touch "$ui_dir/empty"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 1 'empty list only has column labels'
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'display-popup'*'__notice'*'info'*'No worktrees'* ]] || fail "empty inventory notice not shown in popup: ${(j:|:)calls}"
    [[ "$(cat "$ui_dir/options.1")" != *'No worktrees'* ]] || fail 'empty inventory notice leaked into fzf header'
    [[ "$(cat "$ui_dir/options.1")" != *GROUP* ]] || fail 'column labels are in the top fzf header'
    ui_reset
    ui_warning='scan warning detail'
    printf 'ctrl-f\n' > "$ui_dir/reply.1"
    print 1 > "$ui_dir/status.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'display-popup'*'__notice'*'warning'*'scan warning detail'* ]] || fail 'discovery warning not shown in popup'
    [[ "$(cat "$ui_dir/options.1")" != *'scan warning detail'* ]] || fail 'discovery warning leaked into fzf header'
    ui_warning=''
    ui_reset
    touch "$ui_dir/empty"
    printf 'ctrl-f\n' > "$ui_dir/reply.1"
    print 1 > "$ui_dir/status.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/scans" | tr -d ' ')" 2 'empty inventory refresh with fzf status 1 rescans'
    assert_equal "$(cat "$ui_dir/count")" 3 'empty inventory refresh returns to picker'
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 1 'empty list has column labels only'
    assert_equal "$(wc -l < "$ui_dir/rows.2" | tr -d ' ')" 1 'refreshed empty list has column labels only'
    ui_reset
    printf 'ctrl-f\n' > "$ui_dir/reply.1"
    print 1 > "$ui_dir/status.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/scans" | tr -d ' ')" 2 'no-match refresh with fzf status 1 rescans'
    assert_equal "$(cat "$ui_dir/count")" 3 'no-match refresh returns to picker'
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 2 'list has heading and result'
    [[ -s "$ui_dir/rows.2" ]] || fail 'no-match fixture lacks inventory'
    [[ ! -f "$ui_dir/actions" ]] || fail 'no-match refresh dispatches an action'
    ui_reset
    printf 'enter\n1\tforged path\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    result=$(cat "$ui_dir/rows.1")
    [[ "$result" == *$'0\t\e[38;2;138;138;138mREPOSITORY'* ]] || fail "column labels are not a non-selectable list header: $result"
    [[ "$result" == *$'1\t'*project*topic*'tree with spaces'* ]] || fail 'row fields missing'
    [[ "$result" == *$'\e[1;38;2;255;198;0mproject name'* ]] || fail 'repository name lacks Cobalt2 color'
    [[ "$result" != *clean* && "$result" != *dirty* ]] || fail 'clean/dirty status shown in row'
    local field
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[2]}" "$selected_path" 'selection resolves array path instead of returned text'
    ui_reset
    printf 'ctrl-s\n1\tignored\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ "$(cat "$ui_dir/options.1")" == *'--expect=enter,ctrl-s,ctrl-b,ctrl-r,ctrl-d,ctrl-g,ctrl-t,ctrl-f,ctrl-o'* ]] || fail 'new-session key is absent from fzf expect list'
    [[ "$(cat "$ui_dir/options.1")" == *'ctrl-s'*'open session'* ]] || fail 'new-session key is absent from manager header'
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[5]}" session 'new-session key dispatches session mode'
    ui_reset
    ui_flags=main
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    print 1 > "$ui_dir/status.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ ! -f "$ui_dir/actions" ]] || fail 'main worktree removal dispatched'
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'display-popup'*'__notice'*'Main worktree cannot be removed'* ]] || fail 'main worktree destructive-action explanation missing'
    ui_flags=''
    ui_reset
    open_worktree() { print -u2 'exact Git failure'; return 1; }
    printf 'enter\n1\tforged\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    print 1 > "$ui_dir/status.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'display-popup'*'__notice'*'exact Git failure'* ]] || fail 'failure is not visible in popup'
    [[ "$(cat "$ui_dir/options.2")" != *'exact Git failure'* ]] || fail 'action failure leaked into fzf header'
    assert_equal "$(cat "$ui_dir/count")" 4 'manager remains usable after failed action'
    open_worktree() { printf '%s\0' open "$@" >> "$ui_dir/actions"; }
    ui_reset
    printf 'ctrl-f\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/scans" | tr -d ' ')" 2 'refresh rescans'
    [[ ! -f "$ui_dir/actions" ]] || fail 'cancel dispatches action'
    ui_reset
    printf 'ctrl-b\n1\tignored\n' > "$ui_dir/reply.1"
    print 1 > "$ui_dir/reply.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[4]}" refs/heads/other 'checkout selection'
    assert_equal "${calls[5]}" 0 'local checkout boolean'
    [[ "$(tail -n +2 "$ui_dir/rows.2")" != *busy* ]] || fail 'occupied branch is offered'
    ui_reset
    ui_status=dirty
    printf 'ctrl-b\n1\tignored\n' > "$ui_dir/reply.1"
    print 2 > "$ui_dir/reply.2"
    printf 'no\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ ! -f "$ui_dir/actions" ]] || fail 'dirty checkout without confirmation'
    ui_reset
    printf 'ctrl-b\n1\tignored\n' > "$ui_dir/reply.1"
    print 2 > "$ui_dir/reply.2"
    printf 'yes\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[5]}" 1 'remote checkout boolean'
    ui_reset
    printf 'ctrl-r\n1\tignored\n' > "$ui_dir/reply.1"
    printf '%s\nyes\n' "$TEST_DIR/new directory" | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[4]}" "$TEST_DIR/new directory" 'rename preserves destination'
    [[ "$(cat "$ui_dir/output")" == *"$selected_path"*dirty* ]] || fail 'rename safety copy incomplete'
    ui_reset
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'yes\nno\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ ! -f "$ui_dir/actions" ]] || fail 'force removal without second confirmation'
    ui_reset
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'yes\nforce\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'new-window'*'__remove'*'1'* ]] || fail 'force removal launches worker with force enabled'
    [[ "$(cat "$ui_dir/output")" == *"$selected_path"*dirty*FORCE* ]] || fail 'force safety copy incomplete'
    ui_reset
    ui_status=clean
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'yes\n' | manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j:|:)calls}" == *'new-window'*'__remove'*'0'* ]] || fail 'normal removal launches worker without force'
    ui_reset
    selected_path+=$'\nsecond\tline'
    printf 'enter\n1\tforged\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 2 'control characters keep one display row plus labels'
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[2]}" "$selected_path" 'control characters preserved in action path'
    ui_reset
    printf 'enter\n0\tbad\n' > "$ui_dir/reply.1"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ ! -f "$ui_dir/actions" ]] || fail 'invalid zero id dispatches'
    ui_reset
    manager_launch
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j: :)calls}" == *'new-window -n worktree-manager -c '*'/Projects -e WM_RETURN_WINDOW=@9'* ]] || fail 'launcher does not create manager with return context'
    ui_reset
    touch "$ui_dir/existing"
    manager_launch
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j: :)calls}" == *'set-window-option -t @7 @worktree-manager-return @9 select-window -t @7'* ]] || fail 'launcher does not focus existing manager'
    [[ "${(j: :)calls}" != *new-window* ]] || fail 'launcher duplicates manager'
    ui_reset
    local TMUX=fixture
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    calls=(); while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/tmux"
    [[ "${(j: :)calls}" == *'select-window -t @9'* ]] || fail 'quit does not restore previous window'
    [[ "$(rg -c 'bind-key -T git-mode m ' "$WORKSPACE_DIR/tmux/.config/tmux/tmux.conf.local")" == 1 ]] || fail 'm binding missing or conflicting'
    [[ "$(rg '^m' "$WORKSPACE_DIR/tmux/.config/tmux/scripts/popup/help/tables/git-mode.txt")" == *'Global worktree manager'* ]] || fail 'help entry absent'
    unfunction discover_worktrees _worktree_manager_validate list_repository_branches open_worktree checkout_branch rename_worktree remove_worktree fzf tmux ui_reset
    print 'PASS: global worktree interface'
}

test_repo_colors() {
    local manager="$WORKSPACE_DIR/tmux/.config/tmux/scripts/worktree-manager.sh"
    source "$manager"
    local -a sorted_entries
    local i rname tab=$'\t'
    # Create 20 unique repositories
    for ((i=1; i<=20; i++)); do
        printf -v rname 'repo%02d' "$i"
        sorted_entries+=("$rname${tab}main${tab}$TEST_DIR/$rname/wt${tab}$i${tab}$TEST_DIR/$rname")
    done
    local -A repo_colors used_colors
    _worktree_assign_repo_colors
    local -A seen_assigned
    for ((i=1; i<=20; i++)); do
        printf -v rname 'repo%02d' "$i"
        local color="${repo_colors[$TEST_DIR/$rname]}"
        [[ -n "$color" ]] || fail "missing color for $rname"
        [[ -z "${seen_assigned[$color]:-}" ]] || fail "duplicate color assigned: $color"
        seen_assigned[$color]=1
    done
    assert_equal "${#seen_assigned}" 20 "20 unique non-repeating colors assigned"
    # First 14 must match baseline WM_COBALT2_PALETTE
    for ((i=1; i<=14; i++)); do
        printf -v rname 'repo%02d' "$i"
        assert_equal "${repo_colors[$TEST_DIR/$rname]}" "${WM_COBALT2_PALETTE[i]}" "palette color $i matches Cobalt2"
    done
    print 'PASS: global worktree repo colors'
}

case "${1:-all}" in
    config) test_config ;;
    discovery) test_discovery ;;
    actions) test_actions ;;
    interface) test_interface ;;
    colors) test_repo_colors ;;
    all) test_config; test_discovery; test_actions; test_interface; test_repo_colors ;;
    *) fail "unknown test suite: $1" ;;
esac
