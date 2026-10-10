#!/usr/bin/env zsh

set -euo pipefail
SCRIPT_DIR="${0:A:h}"
WORKSPACE_DIR="${SCRIPT_DIR:h:h:h:h}"
DISCOVERY="$WORKSPACE_DIR/tmux/.config/tmux/scripts/lib/worktree-manager/discovery.zsh"
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
    assert_equal "${#fields}" 49 "deduplicated seven worktrees"
    local i expected_path
    for ((i=1; i<=${#fields}; i+=7)); do
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
                    assert_equal "${fields[i+6]}" clean "custom Git directory checkout status"
                else
                    [[ "${fields[i+5]}" != *main* ]] || fail "separate linked worktree marked main"
                fi ;;
            *) fail "unexpected worktree ${fields[i+3]}" ;;
        esac
    done
    for expected_path in "$personal" "$work" "$external" "$nested" "$early" "$separate" "$separate_link"; do
        assert_equal "${path_counts[$expected_path]:-0}" 1 "expected path appears exactly once: $expected_path"
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
    assert_equal "${#fields}" 35 "malformed records skipped and later valid records retained"
    assert_equal "${fields[12]}" '' "detached branch"
    assert_equal "${fields[13]}" 'detached,locked' "detached locked flags"
    assert_equal "${fields[20]}" prunable "prunable flag"
    assert_equal "${fields[21]}" missing "stale status"
    assert_equal "${fields[27]}" bare "bare flag"
    assert_equal "${fields[34]}" '' "stale nested directory must not be main"
    assert_equal "${fields[35]}" unknown "stale registered directory status"
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

test_actions() {
    local actions="$WORKSPACE_DIR/tmux/.config/tmux/scripts/lib/worktree-manager/actions.zsh"
    [[ -f "$actions" ]] || fail "actions library is missing"
    source "$DISCOVERY"
    source "$actions"
    local repo="$TEST_DIR/action repo" linked="$TEST_DIR/linked tree" moved="$TEST_DIR/moved tree"
    local field
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
    git() { printf '%s\0' "$@" >> "$git_log"; command git "$@"; }
    tmux() {
        printf '%s\0' "$@" >> "$tmux_log"
        if [[ "$1" == list-windows ]]; then
            print -r -- 'project:topic'
            print -r -- 'project:topic-2'
        fi
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
    assert_equal "${(j:|:)fields}" "list-windows|-F|#{window_name}|new-window|-n|project:topic-3|-c|$moved" 'collision-safe window arguments'
    remove_worktree "$repo" "$moved" 1
    command git -C "$repo" show-ref --verify --quiet refs/heads/remote-only || fail 'worktree removal deleted branch'
    # Confirm successful mutations have explicit context and no force checkout.
    local joined
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
    local selected_path="$TEST_DIR/tree with spaces" ui_status=clean ui_flags='' ui_add_main=0 ui_add_prunable=0
    local ui_dir="$TEST_DIR/ui" result
    local cache_key="${TEST_DIR}/Projects"
    cache_key="${cache_key//[^A-Za-z0-9]/_}"
    local cache_file="${TMPDIR:-/tmp}/worktree-manager-cache.v6.${cache_key}"
    mkdir -p "$ui_dir"
    discover_worktrees() {
        print x >> "$ui_dir/scans"
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
        printf '%s\0' "$@" >> "$ui_dir/tmux"
        case "$1" in
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
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 2 'main worktrees hidden by default'
    assert_equal "$(wc -l < "$ui_dir/rows.2" | tr -d ' ')" 3 'toggle shows main worktrees'
    [[ "$(cat "$ui_dir/rows.1" "$ui_dir/rows.2")" != *'stale project'* ]] || fail 'prunable worktree appears in picker'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[38;2;255;98;140mctrl-t\e[0m \e[38;2;255;198;0mmains:off'* ]] || fail 'main-worktree toggle state is not shown'
    [[ "$(cat "$ui_dir/options.2")" == *$'\e[38;2;255;98;140mctrl-t\e[0m \e[38;2;255;198;0mmains:on'* ]] || fail 'main-worktree toggle state did not update'
    [[ "$(cat "$ui_dir/options.1")" == *'--ansi'* ]] || fail 'picker does not enable ANSI colors'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[38;2;255;98;140mctrl-d\e[0m'* ]] || fail 'keybinding color missing'
    [[ "$(cat "$ui_dir/options.1")" == *$'\e[0m \e[38;2;255;198;0mremove\e[0m'* ]] || fail 'keybinding description color missing'
    [[ "$(cat "$ui_dir/rows.1")" == *$'0\t\e[38;2;138;138;138mREPOSITORY'* ]] || fail 'column heading delimiter or color missing'
    ui_add_main=0
    ui_add_prunable=0
    ui_reset
    touch "$ui_dir/empty"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    assert_equal "$(wc -l < "$ui_dir/rows.1" | tr -d ' ')" 1 'empty list only has column labels'
    [[ "$(cat "$ui_dir/options.1")" == *'No worktrees'* ]] || fail 'empty inventory explanation absent'
    [[ "$(cat "$ui_dir/options.1")" != *GROUP* ]] || fail 'column labels are in the top fzf header'
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
    [[ "$result" == *$'0\tG  REPOSITORY'* ]] || fail "column labels are not a non-selectable list header: $result"
    [[ "$result" == *$'1\tP '*project*topic*'tree with spaces'* ]] || fail 'row fields missing'
    [[ "$result" != *clean* && "$result" != *dirty* ]] || fail 'clean/dirty status shown in row'
    local -a calls
    local field
    while IFS= read -r -d '' field; do calls+=("$field"); done < "$ui_dir/actions"
    assert_equal "${calls[2]}" "$selected_path" 'selection resolves array path instead of returned text'
    ui_reset
    ui_flags=main
    printf 'ctrl-d\n1\tignored\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    print 1 > "$ui_dir/status.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ ! -f "$ui_dir/actions" ]] || fail 'main worktree removal dispatched'
    [[ "$(cat "$ui_dir/options.2")" == *'Main worktree cannot be removed'* ]] || fail 'main worktree destructive-action explanation missing'
    ui_flags=''
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
    open_worktree() { print -u2 'exact Git failure'; return 1; }
    printf 'enter\n1\tforged\n' > "$ui_dir/reply.1"
    printf 'ctrl-f\n' > "$ui_dir/reply.2"
    manager_main "$TEST_DIR/Projects" > "$ui_dir/output"
    [[ "$(cat "$ui_dir/options.2")" == *'exact Git failure'* ]] || fail 'failure is not visible in next picker'
    assert_equal "$(cat "$ui_dir/count")" 4 'manager remains usable after failed action'
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
    [[ "$(rg -c 'bind-key -T git-mode m ' "$WORKSPACE_DIR/tmux/.tmux.conf.local")" == 1 ]] || fail 'm binding missing or conflicting'
    [[ "$(rg '^m' "$WORKSPACE_DIR/tmux/.config/tmux/scripts/popup/help/tables/git-mode.txt")" == *'Global worktree manager'* ]] || fail 'help entry absent'
    unfunction discover_worktrees _worktree_manager_validate list_repository_branches open_worktree checkout_branch rename_worktree remove_worktree fzf tmux ui_reset
    print 'PASS: global worktree interface'
}

case "${1:-all}" in
    discovery) test_discovery ;;
    actions) test_actions ;;
    interface) test_interface ;;
    all) test_discovery; test_actions; test_interface ;;
    *) fail "unknown test suite: $1" ;;
esac
