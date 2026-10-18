#!/usr/bin/env zsh

emulate -LR zsh
setopt errexit nounset pipefail

script_dir="${0:A:h}"
repo_root="${script_dir}/../../.."
cd "$repo_root"

config_file="$repo_root/tmux/.config/tmux/tmux.conf"
baseline_file="$repo_root/results/tmux-native-config-baseline.md"

fail() {
    print -u2 -- "FAIL: $*"
    exit 1
}

assert_eq() {
    local expected="$1" actual="$2" label="$3"
    [[ "$actual" == "$expected" ]] || fail "$label: expected '$expected', got '$actual'"
}

assert_contains() {
    local value="$1" expected="$2" label="$3"
    [[ "$value" == *"$expected"* ]] || fail "$label: missing '$expected'"
}

assert_color() {
    local style="${1:l}" color="${2:l}" label="$3"
    assert_contains "$style" "$color" "$label"
}

[[ -f "$config_file" ]] || fail "native entrypoint not found: tmux/.config/tmux/tmux.conf"
[[ -f "$baseline_file" ]] || fail "baseline not found: results/tmux-native-config-baseline.md"

for native_file in \
    "$config_file" \
    "$repo_root/tmux/.config/tmux/tmux.conf.local" \
    "$repo_root/tmux/.config/tmux/themes/cobalt2.conf"; do
    if grep -Eq 'tmux_conf_[[:alnum:]_]+=|^set\(\)|^setw\(\)|is_vim=' "$native_file"; then
        fail "OMT shell syntax remains in $native_file"
    fi
done

tmp_dir="$(mktemp -d)"
socket="nc-$$"
test_home="$tmp_dir/home"
plugin_path="$tmp_dir/plugins"

mkdir -p "$test_home/.config/tmux/plugins" "$test_home/.config/tmux/themes" "$plugin_path"
ln -s "$config_file" "$test_home/.config/tmux/tmux.conf"
ln -s "$repo_root/tmux/.config/tmux/tmux.conf.local" "$test_home/.config/tmux/tmux.conf.local"
ln -s "$repo_root/tmux/.config/tmux/themes/cobalt2.conf" \
    "$test_home/.config/tmux/themes/cobalt2.conf"
ln -s "$HOME/.config/tmux/plugins/tpm" "$test_home/.config/tmux/plugins/tpm"
for installed_plugin in "$HOME"/.config/tmux/plugins/*; do
    [[ -d "$installed_plugin" && "${installed_plugin:t}" != tpm ]] \
        || continue
    ln -s "$installed_plugin" "$plugin_path/${installed_plugin:t}"
done

tmux_private() {
    TMUX_TMPDIR="$tmp_dir" tmux -L "$socket" "$@"
}

assert_prefix_binding() {
    local key="$1" expected="$2" actual
    actual="$(tmux_private list-keys -T prefix "$key")" \
        || fail "could not inspect prefix binding $key"
    assert_contains "$actual" "$expected" "prefix binding $key"
}

cleanup() {
    tmux_private kill-server >/dev/null 2>&1 || true
    rm -rf -- "$tmp_dir"
}

trap cleanup EXIT INT TERM

# The isolated manager path prevents accidental plugin installation while the
# server loads plugin declarations and TPM's startup hook.
export TMUX_TMPDIR="$tmp_dir"
export HOME="$test_home"
export TMUX_PLUGIN_MANAGER_PATH="$plugin_path"

test_config="$tmp_dir/test.conf"
printf 'set-environment -g TMUX_PLUGIN_MANAGER_PATH "%s"\nsource-file "%s"\n' \
    "$plugin_path" "$test_home/.config/tmux/tmux.conf" > "$test_config"

tmux_private -f "$test_config" new-session -d -s native-config-test \
    || fail "tmux could not start with tmux/.config/tmux/tmux.conf"

baseline_tables="$tmp_dir/baseline.tables"
baseline_ids="$tmp_dir/baseline.ids"
actual_bindings="$tmp_dir/actual.bindings"
actual_ids="$tmp_dir/actual.ids"

awk '
    /^## Effective key tables$/ { in_tables = 1; next }
    /^Binding count:/ { exit }
    in_tables && /^\| `/ {
        table = $2
        gsub(/`/, "", table)
        print table
    }
' "$baseline_file" | LC_ALL=C sort -u > "$baseline_tables"

awk '
    /^## Effective bindings$/ { in_bindings = 1; next }
    in_bindings && /^```text$/ { in_code = 1; next }
    in_code && /^```$/ { exit }
    in_code && /^bind-key/ {
        for (i = 1; i <= NF; i++) {
            if ($i == "-T") {
                print $(i + 1) "\t" $(i + 2)
                break
            }
        }
    }
' "$baseline_file" | LC_ALL=C sort -u > "$baseline_ids"

tmux_private list-keys -a > "$actual_bindings" \
    || fail "could not read isolated key tables"
awk '
    /^bind-key/ {
        for (i = 1; i <= NF; i++) {
            if ($i == "-T") {
                print $(i + 1) "\t" $(i + 2)
                break
            }
        }
    }
' "$actual_bindings" | LC_ALL=C sort -u > "$actual_ids"

assert_eq 596 "$(wc -l < "$baseline_ids" | tr -d ' ')" "baseline binding identities"
assert_eq 596 "$(wc -l < "$actual_ids" | tr -d ' ')" "isolated binding identities"
diff -u "$baseline_ids" "$actual_ids" || fail "isolated key table/binding identities differ from baseline"

while IFS= read -r table; do
    [[ -n "$table" ]] || continue
    tmux_private list-keys -T "$table" >/dev/null \
        || fail "expected key table is missing: $table"
done < "$baseline_tables"

assert_eq C-a "$(tmux_private show-option -gqv prefix)" "prefix"
assert_eq C-a "$(tmux_private show-option -gqv prefix2)" "secondary prefix"
assert_eq 10000 "$(tmux_private show-option -gqv history-limit)" "history limit"
assert_eq 1000 "$(tmux_private show-option -gqv display-time)" "message display time"
assert_eq 600 "$(tmux_private show-option -gqv repeat-time)" "repeat binding time"
assert_eq on "$(tmux_private show-option -gqv mouse)" "mouse option"
assert_eq 'exec /bin/zsh' "$(tmux_private show-option -gqv default-command)" "default command"
assert_eq top "$(tmux_private show-option -gqv status-position)" "status position"
assert_eq 1 "$(tmux_private show-option -gqv base-index)" "base index"
assert_eq on "$(tmux_private show-option -gqv status)" "status enabled"
assert_eq 10 "$(tmux_private show-option -gqv status-interval)" "status interval"
assert_eq left "$(tmux_private show-option -gqv status-justify)" "status justification"
assert_eq 1000 "$(tmux_private show-option -gqv status-left-length)" "status left length"
assert_eq 1000 "$(tmux_private show-option -gqv status-right-length)" "status right length"
assert_eq on "$(tmux_private show-option -gqv set-titles)" "terminal titles"
assert_eq '#h ❐ #S ● #I #W' "$(tmux_private show-option -gqv set-titles-string)" "terminal title format"
assert_eq off "$(tmux_private show-option -gqv focus-events)" "focus events"
assert_eq on "$(tmux_private show-option -gqv extended-keys)" "extended keys"
assert_eq csi-u "$(tmux_private show-option -gqv extended-keys-format)" "extended key format"
assert_eq on "$(tmux_private show-option -gqv set-clipboard)" "clipboard integration"
assert_eq tmux-256color "$(tmux_private show-option -gqv default-terminal)" "terminal type"
assert_contains "$(tmux_private show-option -gqv terminal-features)" 'xterm*:RGB' "RGB terminal feature"
assert_eq on "$(tmux_private show-option -gqv renumber-windows)" "renumber windows"
assert_eq off "$(tmux_private show-option -gqv detach-on-destroy)" "detach on destroy"
assert_eq 1 "$(tmux_private show-window-option -gv pane-base-index)" "pane base index"
assert_eq vi "$(tmux_private show-window-option -gv mode-keys)" "copy-mode keys"
assert_eq on "$(tmux_private show-window-option -gv monitor-activity)" "activity monitoring"
assert_eq 800 "$(tmux_private show-window-option -gv display-panes-time)" "pane display time"

assert_prefix_binding l 'select-pane -R'
assert_prefix_binding L 'resize-pane -R 2'
assert_prefix_binding m 'if-shell -F'
assert_prefix_binding m 'set -g mouse off'
assert_prefix_binding m 'set -g mouse on'
assert_prefix_binding r 'source-file'
assert_prefix_binding R 'source-file'
copy_mode_escape="$(tmux_private list-keys -T copy-mode-vi Escape)"
assert_contains "$copy_mode_escape" 'send-keys -X cancel' "vi copy-mode Escape exits copy mode"

plugin_config="$(<"$repo_root/tmux/.config/tmux/tmux.conf.local")"
for plugin in \
    tmux-plugins/tmux-sensible \
    nhdaly/tmux-better-mouse-mode \
    tmux-plugins/tmux-yank \
    Morantron/tmux-fingers \
    jtmcginty/tmux-session-dots \
    cesarferreira/tmux.expose \
    joryeugene/tmux-jumplist \
    hamolicious/back-in-5 \
    laktak/tome \
    Subbeh/tmux-tpad; do
    assert_contains "$plugin_config" "@plugin '$plugin'" "declared TPM plugin $plugin"
done

prefix_bindings="$(tmux_private list-keys -T prefix)"
assert_contains "$prefix_bindings" 'install_plugins' "TPM install binding"
assert_contains "$prefix_bindings" 'update_plugins' "TPM update binding"

status_left="$(tmux_private show-option -gqv status-left)"
status_right="$(tmux_private show-option -gqv status-right)"
message_command_style="$(tmux_private show-option -gqv message-command-style)"
message_style="$(tmux_private show-option -gqv message-style)"
message_format="$(tmux_private show-option -gqv message-format)"
copy_selection_style="$(tmux_private display-message -p '#{E:copy-mode-selection-style}')"
copy_selection_option="$(tmux_private show-option -gqv copy-mode-selection-style)"
mode_style="$(tmux_private display-message -p '#{E:mode-style}')"
assert_color "$message_style" 'fill=#ffc600' "display-message full-row background"
assert_color "$message_command_style" 'fill=#1c1c1c' "command prompt full-row background"
assert_color "$(tmux_private display-message -p '#{E:message-style}')" 'fill=#ffc600' "expanded prompt background"
assert_color "$(tmux_private display-message -p '#{E:message-command-style}')" 'fg=#ffc600' "expanded command prompt foreground"
assert_contains "$message_format" '#[width=100%]' "full-width prompt and message area"
assert_contains "$message_format" '#[fill=#1C1C1C]' "command-mode background fill"
assert_contains "$message_format" '#[fill=#ffc600]' "display-message background fill"
assert_color "$copy_selection_option" 'bg=#ffc600' "explicit copy-mode selection background"
assert_eq "$mode_style" "$copy_selection_style" "copy-mode selection matches mode highlight"
status_formats="$status_left $status_right"
assert_eq '#[fg=#080808,bg=#ffc600,bold] ❐ #s #[default]' "${status_left:l}" "session name left status"
[[ "$status_right" != *'#h | ↑'* ]] || fail "status-right still uses the replaced hostname-first layout"
[[ "$status_right" != *'%R'* ]] || fail "status-right still shows the time"
[[ "$status_right" != *'%d %b'* ]] || fail "status-right still shows the date"
for omt_format in session_dots uptime_y uptime_dy uptime_d uptime_h uptime_m username root; do
    [[ "$status_formats" != *"#{${omt_format}}"* ]] \
        || fail "status still depends on OMT format #{${omt_format}}"
done
assert_contains "$status_right" "#[fg=#ffc600,bg=#0d3a58] #(~/.config/tmux/plugins/tmux-session-dots/scripts/session-dots.sh" "spaced yellow native session dots segment"
assert_contains "$status_right" '#[fg=#ffc600,bg=#0050a4,bold]' "legacy uptime segment colors"
assert_contains "$status_right" "s/ days?/d/g" "compact uptime days"
assert_contains "$status_right" "s/ hours?/h/g" "compact uptime hours"
assert_contains "$status_right" "s/ minutes?/m/g" "compact uptime minutes"
assert_contains "$status_right" '#[fg=#080808,bg=#ffc600,bold]' "legacy username segment colors"
assert_contains "$status_right" '↑ #(uptime ' "spaced uptime icon"
[[ "$status_formats" != *'${HOME}/.tmux.conf'* ]] \
    || fail "status still sources helpers from ~/.tmux.conf"

inactive_style="$(tmux_private show-window-option -gv window-status-style)"
last_style="$(tmux_private show-window-option -gv window-status-last-style)"
inactive_format="$(tmux_private show-window-option -gv window-status-format)"
current_format="$(tmux_private show-window-option -gv window-status-current-format)"
current_style="$(tmux_private show-window-option -gv window-status-current-style)"
assert_color "$inactive_style" 'fg=#ffffff' "inactive window foreground"
assert_color "$inactive_style" 'bg=#193549' "inactive window background"
assert_color "$last_style" 'fg=#ffc600' "last-active window foreground"
assert_color "$last_style" 'bg=#193549' "last-active window background"
assert_color "$current_style" 'fg=#1c1c1c' "active window foreground"
assert_color "$current_style" 'bg=#00aaff' "active window background"
assert_contains "${inactive_format:l}" '#[fg=#e4e4e4,bg=#185294] #i #[fg=#e4e4e4,bg=#0d3a58] #w' "inactive window labels"
assert_contains "${current_format:l}" '#[fg=#1c1c1c,bg=#00aaff,bold] #i #[fg=#ffc600,bg=#0f3c5a,bold] #w' "active window labels"
[[ "${inactive_format:l}" != *'#[fg=#ffffff'* ]] \
    || fail "inactive format hard-codes white over last-window style"
print -- "PASS: isolated native tmux config matches all $(wc -l < "$baseline_ids" | tr -d ' ') binding identities and required options, plugins, formats, and colors"
