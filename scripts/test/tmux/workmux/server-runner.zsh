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
[[ "$(detect_project_type "$tmp_dir/node")" == "Node.js project (package.json)" ]]
[[ "$(detect_project_type "$tmp_dir/python")" == "Python project" ]]
[[ "$(detect_project_type "$tmp_dir/empty")" == "Unknown project type" ]]

print "server runner tests passed"
