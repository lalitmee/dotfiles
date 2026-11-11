# OpenCode

Workmux's official V2 status plugin is installed locally, not vendored or loaded
from a fork. Upstream does not provide a `package.json` for Git package loading.
The `plugins/` directory is excluded from Stow to avoid deploying legacy plugins.

Install or update the official plugin:

```sh
mkdir -p "$HOME/.config/opencode/plugins/workmux-status"
for file in index.ts tui.ts status.ts; do
    curl -fsSL -o "$HOME/.config/opencode/plugins/workmux-status/$file" \
        "https://raw.githubusercontent.com/raine/workmux/main/resources/opencode/v2/workmux-status/$file"
done
```

OpenCode discovers this directory automatically; no `plugins` array entry is
needed. Use `/reload` if an existing terminal session does not pick it up.
Status tracking requires the terminal UI, not headless `opencode run`.

Source: <https://workmux.dev/guide/status-tracking/#opencode-setup>
