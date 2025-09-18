# Project Runner System

A sophisticated tmux-based project runner with intelligent process detection and emoji-based naming.

## Features

- **Smart Process Detection**: Automatically detects long-running vs short processes
- **Emoji-Based Naming**: Visual identification (🚀 dev, 🧪 test, 🔨 build, etc.)
- **Status Tracking**: Real-time status updates (✅ completed, ❌ failed, ⏸️ paused)
- **Window Persistence**: Maintains custom names despite tmux's automatic renaming
- **Process Monitoring**: Background monitoring of running processes
- **Registry System**: Tracks running processes across tmux sessions

## Naming Convention

### Window Names
- **Running**: `emoji scriptname` (e.g., `🚀 dev`, `🧪 test`)
- **Completed**: `✅ scriptname` (e.g., `✅ dev`)
- **Failed**: `❌ scriptname` (e.g., `❌ test`)

### Emojis

#### Special Mappings
- `test` → `🧪`
- `lint` → `🔍`
- `build` → `🔨`
- `deploy` → `🚀`
- `storybook` → `📚`
- `docs` → `📖`

#### Long-Running Processes
- `🚀`, `⚡`, `🔄`, `🌐`, `📡`

#### Short Processes
- `🔨`, `🧪`, `🔍`, `📦`, `⚙️`

## Usage

### Keybinding
```
C-a C-r  → Launch project runner
```

### Workflow
1. **Launch**: Press `C-a C-r` to open the project runner
2. **Select**: Choose a script from package.json using fzf
3. **Execute**: Creates a tmux window with emoji-based name
4. **Monitor**: Window name updates with process status
5. **Manage**: Use standard tmux commands to switch between windows

## Examples

### Development Server
- **Command**: `yarn dev`
- **Window Name**: `🚀 dev`
- **Completed**: `✅ dev`

### Test Suite
- **Command**: `npm run test`
- **Window Name**: `🧪 test`
- **Failed**: `❌ test`

### Build Process
- **Command**: `yarn build`
- **Window Name**: `🔨 build`
- **Completed**: `✅ build`

## Architecture

### Files
- `runner.sh` - Main interactive script with fzf interface
- `maintain-window-name.sh` - Hook script for name persistence
- `README.md` - This documentation

### Process Lifecycle
1. **Selection**: User selects script via fzf interface
2. **Naming**: Script gets appropriate emoji and clean name
3. **Creation**: Window created with initial "waiting" status
4. **Execution**: Command runs with status monitoring
5. **Completion**: Window name updated with final status
6. **Persistence**: Background monitoring prevents tmux auto-renaming

## Dependencies

- **jq**: JSON parsing for package.json scripts
- **fzf**: Interactive script selection interface
- **gum**: Styled output and status messages
- **tmux**: Window creation and management

## Configuration

### Tmux Integration
```tmux
# Keybinding
bind C-r display-popup -w 90% -h 90% -E "zsh -l -c '~/.config/tmux/scripts/runner/runner.sh'"

# Window naming controls
set -g allow-rename off
set -g automatic-rename off
setw -g automatic-rename off
setw -g allow-rename off

# Hook to maintain window names
set-hook -g window-renamed 'run-shell "~/.config/tmux/scripts/runner/maintain-window-name.sh #{window_id}"'
```

### Process Classification
```bash
# Long-running processes (dedicated windows)
LONG_RUNNING_KEYWORDS=("dev" "start" "watch" "serve" "storybook")

# Short processes (completion status shown)
# Everything else: build, test, lint, etc.
```

## Benefits

- **Clean Names**: No more emoji clutter, just readable dash-separated names
- **Status Awareness**: Instantly see process completion status
- **No Conflicts**: Multiple processes can run simultaneously
- **Persistent Naming**: Names survive despite tmux's auto-renaming
- **Process Tracking**: Registry system tracks all running processes
- **Error Visibility**: Failed processes clearly marked

## Troubleshooting

### Window Names Resetting
If window names revert to tmux's automatic format (`<index>:command`), the persistence hook may not be working. Check:

1. Hook is properly configured in tmux config
2. `maintain-window-name.sh` script is executable
3. Process registry file exists: `/tmp/tmux-runner-registry-${USER}`

### Popup Not Appearing
If `C-a C-r` doesn't show the popup:

1. Check tmux config syntax: `tmux source ~/.tmux.conf.local`
2. Verify runner script exists and is executable
3. Ensure dependencies are installed: `jq`, `fzf`, `gum`

### Process Not Monitored
If processes don't show completion status:

1. Check if process PID was captured correctly
2. Verify background monitoring is running
3. Check registry file for process entries