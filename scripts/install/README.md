# Complete System Setup Installer

A comprehensive, modular installation system for setting up a complete development environment on Ubuntu with i3 window manager. This system strictly follows the decisions made in the `SYSTEM_SETUP_CONTEXT.md` file.

## 🚀 Quick Start

```bash
# Make the installer executable
chmod +x scripts/install/main-installer.zsh

# Run the interactive installer
./scripts/install/main-installer.zsh
```

## 📋 Installation Phases

### Phase 0: Base Ubuntu Setup ⭐ (Critical)
- git (version control)
- curl and wget (download tools)
- build-essential (compilation tools)
- software-properties-common (package management)

### Phase 1: i3 Core ⭐ (Critical)
- i3-wm (window manager)
- i3lock (screen locker)
- xss-lock (screen locking integration)
- dex (desktop entry execution)
- lxappearance (GTK theme management)

### Phase 2: i3 Enhanced ⭐ (Critical)
- **i3ass suite**: i3run, i3viswiz, i3flip, i3Kornhe, i3fyra, i3zen
- sxhkd (hotkey daemon)
- rofi (application launcher)
- polybar (status bar)
- picom (compositor)
- feh (wallpaper setter)
- ulauncher (application launcher)
- flameshot (screenshot tool)
- blueman (bluetooth manager)
- thunar (file manager)
- xpad (sticky notes)
- cbatticon (battery tray icon)
- unclutter (mouse cursor hider)
- btop (system monitor)
- cmus (terminal music player)
- playerctl (media control)

### Phase 3: System Foundation ⭐ (Critical)
- zsh + oh-my-zsh + powerlevel10k
- tmux + TPM
- fzf (fuzzy finder)
- ripgrep (search tool)
- bat (cat replacement)
- lsd (ls replacement)
- stow (dotfile manager)
- gum (TUI framework)
- zoxide (smarter cd)
- atuin (shell history)
- wakatime (time tracking)
- sesh (session manager)
- tmuxinator (tmux session manager)

### Phase 4: Development Core ⭐ (Critical)
- neovim (editor)
- pyenv (Python version manager)
- rbenv (Ruby version manager)
- fnm (Node.js version manager)
- lazygit (git TUI)

### Phase 5: Productivity Layer 🟡 (High Priority)
- ghostty (terminal)

### Phase 6: Desktop Apps 🟡 (Medium Priority)
- **Browsers**: Brave, Firefox
- **Communication**: Slack, Telegram
- **Music**: Spotify
- **Password Manager**: Bitwarden

### Phase 7: Final Setup 🔵 (Low Priority)
- **Fonts**: FiraCode, JetBrains Mono Nerd Fonts
- **Themes**: Arc GTK theme
- Post-installation script

## 🎯 What Gets Installed

### Core System (Always Recommended)
- ✅ i3 window manager with full i3ass suite
- ✅ zsh + tmux + neovim
- ✅ Development tools (pyenv, rbenv, fnm, lazygit)
- ✅ Essential CLI tools (fzf, ripgrep, bat, lsd, stow, gum)
- ✅ Productivity tools (zoxide, atuin, sesh, tmuxinator)
- ✅ Desktop applications (brave, firefox, spotify)

### Installation Philosophy
- **Apt-only**: Uses only apt, cargo, and go for installations (no snap, no brew)
- **Context-driven**: Strictly follows `SYSTEM_SETUP_CONTEXT.md` decisions
- **Minimal**: Only installs tools explicitly listed in the context file
- **Current usage**: Prioritizes your existing workflow tools

## 🔧 Prerequisites

Before running the installer, ensure you have:

```bash
# Required packages (these will be installed in Phase 0)
sudo apt update
sudo apt install -y curl wget git build-essential

# If gum is not available, install it:
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

## 📋 Post-Installation Steps

After installation completes:

1. **Log out and log back in** to apply all changes
2. **Run your dotfiles stow script**:
   ```bash
   ./install
   ```
3. **Configure your themes**:
   ```bash
   lxappearance  # GTK theme configuration
   ```
4. **Set wallpaper**:
   ```bash
   feh --bg-scale /path/to/wallpaper.jpg
   ```
5. **Set up your git configuration** from your dotfiles

## 🛠️ Troubleshooting

### Common Issues

**i3 doesn't start automatically:**
```bash
# Check your display manager configuration
sudo dpkg-reconfigure lightdm
```

**Fonts don't display correctly:**
```bash
# Update font cache
fc-cache -fv
```

**Polybar doesn't start:**
```bash
# Check if all dependencies are installed
./scripts/install/phases/02-i3-enhanced.zsh
```

**Neovim plugins don't load:**
```bash
# Ensure Lazy.nvim is properly installed
nvim --headless -c 'Lazy sync' -c 'qa'
```

### Recovery Options

**Reset to clean state:**
```bash
# Remove i3 configuration
rm -rf ~/.config/i3
# Re-run stow
./install
```

**Reinstall specific component:**
```bash
# Reinstall polybar
./scripts/install/phases/02-i3-enhanced.zsh
```

## 📁 File Structure

```
scripts/install/
├── main-installer.zsh      # Main interactive installer
├── utils.zsh              # Shared utility functions
├── test-setup.zsh         # Installation verification
├── phases/                # Installation phases
│   ├── 00-base-ubuntu.zsh
│   ├── 01-i3-core.zsh
│   ├── 02-i3-enhanced.zsh
│   ├── 03-system-foundation.zsh
│   ├── 04-development-core.zsh
│   ├── 05-productivity-layer.zsh
│   ├── 06-desktop-apps.zsh
│   └── 07-final-setup.zsh
├── SYSTEM_SETUP_CONTEXT.md # Decision framework
└── README.md              # This file
```

## 🎨 Customization

### Skip Specific Applications
Edit the context file to mark applications as skipped:
```markdown
### 2. BROWSERS
❌ SKIP: vivaldi, chromium
```

### Add Custom Applications
Add new installation commands to the appropriate phase script (following apt-only rule).

### Modify Installation Order
Reorder phases in the main installer if needed.

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the context file for your specific configuration
3. Run individual phases to isolate problems
4. Check system logs: `journalctl -xe`

## 🔄 Updates

To update the installation system:
```bash
cd ~/dotfiles
git pull
# Re-run installer with desired options
```

## 📝 License

This installation system is part of your personal dotfiles and follows the same license terms.

---

**Happy coding! 🎉**

*Generated for Lalit Kumar's development environment*
*Strictly follows SYSTEM_SETUP_CONTEXT.md decisions*