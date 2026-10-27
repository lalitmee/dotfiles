#!/usr/bin/env zsh

set -euo pipefail

script_dir="${0:A:h}"
repo_root="${script_dir:h:h:h:h}"
runner="$repo_root/tmux/.config/tmux/scripts/popup/runner/server-runner.sh"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

source "$runner"

mkdir -p "$tmp_dir/node" "$tmp_dir/python" "$tmp_dir/empty"
cat > "$tmp_dir/node/package.json" <<'EOF'
{
  "scripts": {
    "build": "vite build",
    "dev": "vite --host",
    "serve:local": "vite preview",
    "test": "vitest",
    "start": "node server.js"
  }
}
EOF
cat > "$tmp_dir/python/pyproject.toml" <<'EOF'
[project]
name = "sample"
EOF

scripts=("${(@f)$(discover_server_scripts "$tmp_dir/node/package.json")}")
[[ "${(j:,:)scripts}" == "dev,serve:local,start" ]]
server_scripts=("${scripts[@]}")
[[ "$(server_action_key 1)" == "1" ]]
[[ "$(server_action_key 10)" == "0" ]]
[[ "$(server_action_key 11)" == "a" ]]
[[ "$(resolve_server_key 2)" == "2" ]]
if resolve_server_key z >/dev/null; then
    print -u2 "FAIL: unknown server key resolved"
    exit 1
fi
[[ "$(server_action_key 17)" != "q" ]]
[[ "$(detect_project_type "$tmp_dir/node")" == "Node.js project" ]]
[[ "$(detect_project_type "$tmp_dir/python")" == "Python project" ]]
[[ "$(detect_project_type "$tmp_dir/empty")" == "Unknown project type" ]]

# Rendering must preserve ANSI colors through both gum style calls and center the card.
server_terminal_geometry() { print -r -- '100 35'; }
clear() { :; }
cd -- "$tmp_dir/node"
rendered="$(render_server_menu 'Node.js project' npm)"
[[ "$rendered" == *$'\e[38;2;0;170;255m'* ]] || { print -u2 'FAIL: cyan border/rows missing'; exit 1; }
[[ "$rendered" == *$'\e[38;2;255;198;0m'* ]] || { print -u2 'FAIL: yellow heading missing'; exit 1; }
[[ "$rendered" == *'Workmux Server Launcher'* && "$rendered" == *'Enter'*'Default'* ]] || {
    print -u2 'FAIL: server card content missing'
    exit 1
}
[[ "$rendered" != *'\\e['* && "$rendered" != *'Press a command key'* ]] || {
    print -u2 'FAIL: raw escapes or external prompt in card'
    exit 1
}
plain_rendered="$(print -r -- "$rendered" | sed -E 's/\x1b\[[0-9;]*m//g')"
print -r -- "$plain_rendered" | awk '
    /npm run dev/ { dev = index($0, "npm run dev"); first_hint = index($0, "press 1") }
    /npm run start/ { start = index($0, "npm run start"); last_hint = index($0, "press 3") }
    END { exit !(dev > 0 && dev == start && first_hint > 0 && first_hint == last_hint) }
' || { print -u2 'FAIL: server command or hint columns are not aligned'; exit 1; }

server_terminal_geometry() { print -r -- '64 35'; }
server_scripts=('dev' 'serve:local-with-a-very-long-script-name')
narrow="$(render_server_menu 'Node.js project' npm | sed -E 's/\x1b\[[0-9;]*m//g')"
[[ "$narrow" == *'serve:local…'* && "$narrow" != *'press 1'* ]] || {
    print -u2 'FAIL: narrow server rows are not compact or truncated'
    exit 1
}

print "server runner tests passed"
