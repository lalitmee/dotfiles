# 🚀 Advanced i3 Configuration

A highly optimized, feature-rich i3 window manager setup with dual monitor support, smart workspace assignment, and comprehensive automation.

## ✨ Key Features

- 🎯 **Smart Workspace Assignment** - Automatic window-to-workspace assignment using Python
- 🖥️ **Dual Monitor Optimization** - Workspace distribution across two displays
- 🚀 **Optimized Autostart** - Staggered application startup for performance
- 📱 **Scratchpad System** - Predefined floating windows and utilities
- 📐 **Layout Management** - Saved and restorable window layouts
- 🎨 **Visual Polish** - Custom colors, gaps, and modern appearance
- ⌨️ **Vim-style Navigation** - Intuitive keybindings with hjkl
- 🔧 **Extensive Customization** - Modular configuration system

## 📋 Table of Contents

1. [Requirements & Dependencies](#requirements--dependencies)
2. [Quick Start](#quick-start)
3. [Configuration Structure](#configuration-structure)
4. [i3ass Integration](#i3ass-integration)
5. [Smart Workspace Assignment](#smart-workspace-assignment)
6. [Dual Monitor Setup](#dual-monitor-setup)
7. [Visual Customization](#visual-customization)
8. [Autostart Applications](#autostart-applications)
9. [Scratchpads & Floating Windows](#scratchpads--floating-windows)
10. [Keybindings](#keybindings)
11. [Layout Management](#layout-management)
12. [Customization Guide](#customization-guide)
13. [Troubleshooting](#troubleshooting)
14. [File Structure](#file-structure)

## 🛠️ Requirements & Dependencies

### System Requirements
- Linux distribution with X11 support
- i3 window manager (i3-gaps recommended)
- Python 3.6+ with pip

### Required Packages
```bash
# Core dependencies
sudo apt install i3 i3-gaps i3ipc python3-pip

# Visual components
sudo apt install picom feh polybar

# System utilities
sudo apt install x11-xserver-utils xbacklight amixer pulseaudio
sudo apt install sxhkd unclutter cbatticon

# Additional i3 tools
# The only way to install i3ass is from source:
git clone https://github.com/budlabs/i3ass
cd i3ass
sudo make install

# For complete documentation, see: https://github.com/budlabs/i3ass/blob/next/README.md

# Applications (as used in config)
sudo apt install brave-browser vivaldi spotify slack-desktop
```

### Python Dependencies
```bash
# Install i3ipc for workspace assignment
pip install i3ipc

# Install i3ass suite from budlabs (optional)
# See i3ass Integration section below for details
```

## 🚀 Quick Start

### 1. Clone Configuration
```bash
git clone <your-repo> ~/.config/i3
```

### 2. Install Dependencies
```bash
# Install system packages
sudo apt install i3 i3-gaps i3ipc python3-pip picom feh polybar

# Install Python packages
pip install i3ipc

# Install i3ass suite from budlabs (optional)
# See i3ass Integration section below for details
```

### 3. Setup Scripts
```bash
# Make scripts executable
chmod +x ~/.config/i3/scripts/*.py
chmod +x ~/.config/i3/scripts/discover-window-classes.py
```

### 4. Restart i3
```bash
i3-msg restart
```

### 5. Verify Setup
```bash
# Check workspace assignment script
tail -f /tmp/i3-smart-assign.log

# Discover window classes
~/.config/i3/scripts/discover-window-classes.py
```

## 📁 Configuration Structure

The configuration uses a modular include system for organization:

```
~/.config/i3/
├── config                 # Main configuration file
├── autostart/            # Application startup configurations
│   ├── applications.conf  # Autostart applications
│   ├── workspaces.conf   # Workspace definitions
│   └── xrandr.conf     # Monitor setup
├── keybindings/          # Modular keybinding files
│   ├── volume.conf      # Audio controls
│   ├── brightness.conf  # Brightness controls
│   └── player.conf     # Media player controls
├── scripts/             # Custom automation scripts
│   ├── i3-smart-assign.py    # Workspace assignment script
│   ├── discover-window-classes.py # Window discovery tool
│   └── assignments.json        # Application-to-workspace mapping
├── layouts/             # Saved window layouts
├── gaps.conf           # Window gap settings
├── colors.conf         # Color scheme
└── scratchpads.conf    # Floating window configurations
```

## 🛠️ i3ass Integration

### Overview
i3ass is a comprehensive suite of advanced i3 utilities from budlabs that provides enhanced window management capabilities beyond standard i3 functionality.

### Available Tools
The i3ass suite includes 12 specialized utilities:

| Tool | Purpose | Description |
|------|---------|-------------|
| **i3ass** | Environment info | Print current i3 environment and settings |
| **i3flip** | Window flipping | Flip windows between workspaces/outputs |
| **i3fyra** | File operations | File system operations with i3 integration |
| **i3get** | Window management | Advanced window querying and management |
| **i3gw** | Gateway/Router | Network gateway functionality for i3 |
| **i3info** | System information | Display detailed i3 system information |
| **i3king** | Advanced management | Enhanced window and workspace control |
| **i3Kornhe** | Shell integration | Shell scripting integration for i3 |
| **i3list** | Listing utilities | List windows, workspaces, outputs |
| **i3menu** | Menu generation | Dynamic menu creation for i3 |
| **i3run** | Application launcher | Advanced application launching |
| **i3var** | Variable management | Environment variable management |
| **i3viswiz** | Visual wizard | Visual configuration interface |
| **i3zen** | Minimalist interface | Simplified i3 interface |

### Installation

#### Method 1: From Source (Recommended)
```bash
git clone https://github.com/budlabs/i3ass
cd i3ass
sudo make install
```

#### Method 2: Cargo (Rust-based)
```bash
cargo install i3ass
```

#### Method 3: Package Manager
```bash
# Check availability first
sudo apt install i3ass
```

### Integration with Current Setup

#### Environment Variables
i3ass sets up these environment variables:
- `I3FYRA_WS` - Current workspace information
- `I3FYRA_MAIN_CONTAINER` - Main container tracking

#### Autostart Integration
Add to your `autostart/applications.conf`:
```bash
# Start i3ass daemon (if needed)
exec --no-startup-id i3ass --daemon

# Use specific tools
exec --no-startup-id i3ass --tool i3flip
```

#### Usage Examples
```bash
# Show environment information
i3ass

# Flip current window to next workspace
i3flip

# Get detailed window information
i3info

# List all windows with details
i3list

# Launch application with i3ass integration
i3run firefox

# Manage environment variables
i3var set WORKSPACE=2

# Create dynamic menu
i3menu

# Visual configuration wizard
i3viswiz
```

### Configuration
i3ass tools can be configured through:
- Configuration files in `~/.config/i3ass/`
- Environment variables
- Command-line flags
- Interactive configuration wizards

### Benefits for Your Setup
- **Enhanced Workspace Management**: Advanced workspace switching and organization
- **Improved Window Control**: Better window querying and manipulation
- **Script Integration**: Shell scripting capabilities for automation
- **Visual Tools**: Configuration wizards and visual interfaces
- **Performance Monitoring**: System information and diagnostics

### Documentation
For complete documentation of all i3ass tools:
- **Wiki**: https://github.com/budlabs/i3ass/wiki
- **Examples**: https://github.com/budlabs/i3ass/wiki/i3-config-example
- **Issues**: https://github.com/budlabs/i3ass/issues

## 🎯 Smart Workspace Assignment

### Overview
A Python-based system that automatically assigns the first window of each application to its designated workspace, while allowing additional windows to open anywhere.

### How It Works
1. **Detection**: Monitors for new window events using i3ipc
2. **Matching**: Compares window class against assignment rules
3. **Counting**: Identifies if it's the first window of that class
4. **Assignment**: Moves first window to designated workspace
5. **Logging**: Comprehensive debug information for troubleshooting

### Current Assignments
| Application | Workspace | Window Classes |
|------------|------------|----------------|
| Slack | 1 | `slack`, `Slack` |
| Brave Browser | 2 | `brave-browser`, `Brave-browser` |
| Ghostty | 3 | `ghostty`, `com.mitchellh.ghostty` |
| Vivaldi | 4 | `vivaldi-stable`, `Vivaldi-stable` |
| Spotify | 5 | `spotify`, `Spotify` |

### Customizing Assignments

Edit `~/.config/i3/scripts/assignments.json`:

```json
{
    "application-name": {
        "classes": ["class1", "class2"],
        "workspace": "workspace-number"
    }
}
```

### Debug Tools

**View Live Logs:**
```bash
tail -f /tmp/i3-smart-assign.log
```

**Discover Window Classes:**
```bash
~/.config/i3/scripts/discover-window-classes.py
```

**Manual Testing:**
```bash
# Restart the assignment script
pkill -f i3-smart-assign.py
~/.config/i3/scripts/venv/bin/python ~/.config/i3/scripts/i3-smart-assign.py &
```

## 🖥️ Dual Monitor Setup

### Monitor Configuration
- **Primary Monitor (fm)**: DP-1 (First Monitor)
- **Secondary Monitor (sm)**: DP-2 (Second Monitor)

### Workspace Distribution
| Monitor | Workspaces |
|---------|------------|
| DP-1 (fm) | 2, 4, 5, 11 |
| DP-2 (sm) | 1, 3, 6, 10 |

### Customizing Monitor Setup

Edit `~/.config/i3/config`:
```bash
# Monitor variables
set $fm DP-1  # Change to your primary monitor
set $sm DP-2  # Change to your secondary monitor

# Workspace assignments
workspace $ws2 output $fm
workspace $ws4 output $fm
# ... etc
```

### XRandr Profiles

Multiple monitor profiles are configured in `autostart/xrandr.conf`:
- Laptop only
- External monitor only
- Dual monitor setups
- Different arrangements

## 🎨 Visual Customization

### Color Scheme
Modern blue-themed color palette defined in `colors.conf`:

```bash
# Focused windows: Blue accent
client.focused          #00AAFF #285577 #ffffff #FF628C

# Inactive: Dark gray
client.focused_inactive #333333 #5f676a #ffffff #484e50

# Unfocused: Darker gray
client.unfocused        #333333 #222222 #888888 #292d2e
```

### Gaps and Borders
```bash
# Window gaps
gaps inner 5

# Border style
default_border pixel 2
default_floating_border pixel 2
```

### Font Configuration
```bash
font pango:MonoLisa Nerd Font 8
```

### Customizing Colors

Edit `~/.config/i3/colors.conf`:
```bash
# Format: border background text indicator child_border
client.focused          #BORDER #BACKGROUND #TEXT #INDICATOR #CHILD_BORDER
```

## 🚀 Autostart Applications

### Startup Sequence (Optimized)
Applications start in phases for optimal performance:

1. **System Setup** (Immediate)
   - Keyboard mapping (Caps→Esc)
   - X resources
   - sxhkd (keybinding daemon)
   - PulseAudio
   - Workspace assignment script

2. **Visual Components** (Immediate)
   - Picom compositor
   - Wallpaper with feh

3. **Applications** (Immediate)
   - Ghostty (terminal)
   - Brave Browser
   - Vivaldi Browser
   - Slack (collaboration)
   - Spotify (music)

4. **Background Utilities** (Immediate)
   - Battery monitor
   - Mouse hider
   - Custom alerts

### Customizing Autostart

Edit `~/.config/i3/autostart/applications.conf`:

```bash
# Add new application
exec --no-startup-id application-name

# Add with environment variable
exec --no-startup-id env VAR=value application-name

# Add with shell command
exec --no-startup-id sh -c 'command && application'
```

## 📱 Scratchpads & Floating Windows

### Predefined Scratchpads

| Application | Size | Position | Purpose |
|------------|-------|----------|---------|
| Spotify | 1680×900 | Center | Music player |
| Todoist | 1680×900 | Center | Task management |
| Notes | 1480×900 | 1408×40 | Quick notes |
| Terminal | 1680×1000 | Center | Scratch terminal |
| Monitor | 1880×1000 | Center | System monitoring |

### Adding New Scratchpads

Edit `~/.config/i3/scratchpads.conf`:

```bash
# Basic scratchpad
for_window [class="Application"] floating enable, resize set WIDTH HEIGHT, move position center

# Positioned scratchpad
for_window [title="my-scratch"] floating enable, resize set 1480 900, move position 1408 40

# Specialized scratchpad
for_window [class="App"] floating enable, resize set 1680 1000, move position center
```

### Scratchpad Usage

1. **Show/Hide**: Use defined keybindings
2. **Move to Scratchpad**: `$mod+Shift+-` 
3. **Show Scratchpad**: `$mod+-`

## ⌨️ Keybindings

### Navigation (Vim-style)
```bash
$mod+h  # Focus left
$mod+j  # Focus down
$mod+k  # Focus up
$mod+l  # Focus right

$mod+Shift+h  # Move window left
$mod+Shift+j  # Move window down
$mod+Shift+k  # Move window up
$mod+Shift+l  # Move window right
```

### Media Controls
```bash
XF86AudioPlay/Pause    # Play/Pause
XF86AudioNext         # Next track
XF86AudioPrev         # Previous track
XF86AudioMute         # Mute/Unmute
XF86AudioRaiseVolume   # Volume up
XF86AudioLowerVolume   # Volume down
```

### System Controls
```bash
XF86MonBrightnessUp    # Brightness up
XF86MonBrightnessDown  # Brightness down
$mod1+Tab            # Workspace back and forth
```

### Adding Custom Keybindings

Create new files in `~/.config/i3/keybindings/` or add to main config:

```bash
# In main config
bindsym $mod+key command

# In separate file (included in main config)
# ~/.config/i3/keybindings/custom.conf
bindsym $mod+key command
```

## 📐 Layout Management

### Saved Layouts
Predefined layouts for common application setups:

- `1-slack.json` - Slack workspace layout
- `2-brave.json` - Browser layout
- `3-ghostty.json` - Terminal layout
- `4-vivaldi.json` - Secondary browser layout
- `5-spotify.json` - Music player layout

### Using Layouts

```bash
# Apply saved layout
i3-msg "append_layout ~/.config/i3/layouts/layout-name.json"

# Layout manager script (if available)
~/.config/i3/layout-manager.sh
```

### Creating Custom Layouts

1. Arrange windows as desired
2. Save layout:
```bash
i3-msg "append_layout ~/.config/i3/layouts/my-layout.json"
```

3. Edit the generated file if needed
4. Include in autostart or apply manually

## 🔧 Customization Guide

### Adding New Applications

1. **Discover Window Class:**
```bash
~/.config/i3/scripts/discover-window-classes.py
```

2. **Add to Assignments:**
```json
{
    "new-app": {
        "classes": ["class-name", "Class-Name"],
        "workspace": "6"
    }
}
```

3. **Add to Autostart (optional):**
```bash
exec --no-startup-id new-app
```

### Modifying Workspaces

1. **Edit Workspace Variables** in `autostart/workspaces.conf`:
```bash
set $ws6 "6"
set $ws7 "7"
# ... add more as needed
```

2. **Assign to Monitor**:
```bash
workspace $ws6 output $fm  # or $sm
```

### Changing Colors

Edit `~/.config/i3/colors.conf`:
```bash
# Use color picker to find values
client.focused          #BORDER #BACKGROUND #TEXT #INDICATOR #CHILD_BORDER
```

### Adding New Keybindings

1. **Create new file**: `~/.config/i3/keybindings/custom.conf`
2. **Add keybindings**:
```bash
# Application launcher
bindsym $mod+space exec dmenu_run

# Screenshot
bindsym $mod+Shift+s exec scrot

# File manager
bindsym $mod+Shift+f exec thunar
```

3. **Include in main config**:
```bash
include $HOME/.config/i3/keybindings/custom.conf
```

## 🐛 Troubleshooting

### Common Issues

**Windows not assigning to correct workspaces:**
```bash
# Check window classes
~/.config/i3/scripts/discover-window-classes.py

# Check assignment logs
tail -f /tmp/i3-smart-assign.log

# Restart assignment script
pkill -f i3-smart-assign.py
~/.config/i3/scripts/venv/bin/python ~/.config/i3/scripts/i3-smart-assign.py &
```

**Applications not starting:**
```bash
# Check autostart syntax
i3-msg config

# Test manually
exec --no-startup-id application-name

# Check logs
journalctl -u i3
```

**Monitor setup issues:**
```bash
# Check connected monitors
xrandr --query

# Test monitor configuration
xrandr --output DP-1 --mode 1920x1080 --pos 0x0

# Reload monitor config
i3-msg restart
```

**Performance issues:**
```bash
# Check for resource-heavy applications
htop

# Disable compositor temporarily
killall picom

# Check i3 configuration
i3-msg config
```

### Debug Commands

**Configuration Check:**
```bash
# Validate i3 configuration
i3-msg -C config

# Check loaded configuration
i3-msg config
```

**Window Information:**
```bash
# Get window properties
xprop | grep WM_CLASS

# Check current windows
i3-msg -t get_tree
```

**Log Analysis:**
```bash
# i3 logs
journalctl -u i3 -f

# Assignment script logs
tail -f /tmp/i3-smart-assign.log

# X11 logs
journalctl -u xorg
```

### Recovery Procedures

**Reset to default layout:**
```bash
# Restart i3 cleanly
i3-msg restart

# Or reload configuration
i3-msg reload
```

**Emergency terminal:**
```bash
# Open terminal if i3 is unresponsive
$mod+Shift+Enter  # Default i3 binding
# or
$mod+Shift+Return
```

## 📁 File Structure

```
~/.config/i3/
├── config                    # Main configuration file with includes
├── autostart/               # Startup configurations
│   ├── applications.conf     # Application autostart sequence
│   ├── workspaces.conf      # Workspace definitions and assignments
│   └── xrandr.conf        # Monitor setup profiles
├── keybindings/              # Modular keybinding files
│   ├── volume.conf         # Audio control keybindings
│   ├── brightness.conf     # Brightness control keybindings
│   └── player.conf        # Media player keybindings
├── scripts/                 # Custom automation scripts
│   ├── i3-smart-assign.py      # Main workspace assignment script
│   ├── discover-window-classes.py # Window class discovery tool
│   ├── assignments.json          # Application-to-workspace mapping
│   └── venv/                  # Python virtual environment
├── layouts/                 # Saved window layouts
│   ├── 1-slack.json       # Slack workspace layout
│   ├── 2-brave.json       # Browser layout
│   ├── 3-ghostty.json     # Terminal layout
│   ├── 4-vivaldi.json     # Secondary browser layout
│   └── 5-spotify.json     # Music player layout
├── gaps.conf               # Window gap settings
├── colors.conf             # Color scheme definitions
└── scratchpads.conf        # Floating window configurations
```

### File Purposes

| File/Directory | Purpose |
|----------------|---------|
| `config` | Main configuration with includes and basic settings |
| `autostart/` | Application startup and workspace configuration |
| `keybindings/` | Modular keybinding definitions |
| `scripts/` | Custom automation and workspace assignment |
| `layouts/` | Saved window layouts for quick restoration |
| `gaps.conf` | Window spacing and gap settings |
| `colors.conf` | Color scheme for different window states |
| `scratchpads.conf` | Floating window configurations |
| `i3ass` | Advanced i3 utilities suite from budlabs |

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to improve this configuration.

## 📄 License

This configuration is provided as-is for educational and personal use. Modify and adapt to your needs.

---

**Enjoy your optimized i3 setup! 🎉**

For issues or questions, refer to the [Troubleshooting](#troubleshooting) section or check the debug logs.