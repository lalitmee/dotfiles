# 🎯 System Setup Context & Decision Framework

## Core Philosophy
- **Selective Installation**: Only install what you actively use
- **No Bloat**: Avoid duplicate functionality
- **Current Usage First**: Prioritize your current workflow tools
- **Future-Proof**: Leave room for easy addition of alternatives

---

## 📋 Application Categories & Choices

### 1. TERMINALS
**Current: Ghostty** ✅
```
✅ INSTALL: ghostty (your current terminal)
❌ SKIP: wezterm, kitty, alacritty, urxvt, xterm
```
**Reasoning**: You have extensive ghostty configuration and use it as primary terminal.

### 2. BROWSERS
**Current: Brave + Firefox** ✅
```
✅ INSTALL: brave-browser, firefox
❌ SKIP: vivaldi, chromium, google-chrome, opera
```
**Reasoning**: You use both for different purposes (Brave for daily, Firefox for dev).

### 3. EDITORS
**Current: Neovim** ✅
```
✅ INSTALL: neovim (with Lazy.nvim ecosystem)
❌ SKIP: vscode, emacs, vim, sublime-text
```
**Reasoning**: Extensive nvim config with CodeCompanion, LSP, etc.

### 4. WINDOW MANAGERS
**Current: i3-wm** ✅
```
✅ INSTALL: i3-wm + i3ass suite
❌ SKIP: awesome, dwm, xmonad, bspwm
```
**Reasoning**: Deep i3 customization with layouts, keybindings, themes.

### 5. STATUS BARS
**Current: Polybar** ✅
```
✅ INSTALL: polybar (with custom scripts)
❌ SKIP: i3status, i3blocks, lemonbar
```
**Reasoning**: Extensive polybar config with pomodoro, spotify, etc.

### 6. APPLICATION LAUNCHERS
**Current: Rofi + Ulauncher** ✅
```
✅ INSTALL: rofi (primary), ulauncher (secondary)
❌ SKIP: dmenu, gmrun, synapse
```
**Reasoning**: Rofi for quick app launching, Ulauncher for search.

### 7. COMPOSITORS
**Current: Picom** ✅
```
✅ INSTALL: picom
❌ SKIP: compton, xcompmgr
```
**Reasoning**: Modern picom with blur, animations, etc.

### 8. FILE MANAGERS
**Current: Thunar** ✅
```
✅ INSTALL: thunar
❌ SKIP: nautilus, dolphin, nemo, ranger, lf
```
**Reasoning**: Lightweight GTK file manager that fits i3.

### 9. MUSIC PLAYERS
**Current: Spotify + CMUS** ✅
```
✅ INSTALL: spotify, cmus
❌ SKIP: vlc, mpd, ncmpcpp, rhythmbox
```
**Reasoning**: Spotify for streaming, CMUS for local terminal music.

### 10. PASSWORD MANAGERS
**Current: Bitwarden** ✅
```
✅ INSTALL: bitwarden
❌ SKIP: keepassxc, lastpass, 1password
```
**Reasoning**: Your sxhkd config shows bitwarden usage.

### 11. BLUETOOTH MANAGERS
**Current: Blueman** ✅
```
✅ INSTALL: blueman-manager
❌ SKIP: blueberry, gnome-bluetooth
```
**Reasoning**: Referenced in your scratchpad config.

### 12. SCREENSHOT TOOLS
**Current: Flameshot** ✅
```
✅ INSTALL: flameshot
❌ SKIP: scrot, maim, spectacle
```
**Reasoning**: Configured in sxhkd hotkeys.

### 13. SYSTEM MONITORS
**Current: BTM (bottom)** ✅
```
✅ INSTALL: btm
❌ SKIP: htop, top, glances, bashtop
```
**Reasoning**: Used in scratchpad config.

### 14. NOTE-TAKING/STICKY NOTES
**Current: XPad + Org-mode** ✅
```
✅ INSTALL: xpad, neovim (for org-mode notes)
❌ SKIP: cherrytree, zim, tomboy, gnote
```
**Reasoning**: XPad for sticky notes, neovim for org-mode.

### 15. TASK MANAGEMENT
**Current: Todoist + Org-mode** ✅
```
✅ INSTALL: todoist, neovim (for org-mode)
❌ SKIP: taskwarrior, todo.txt, rememberthemilk
```
**Reasoning**: Todoist for GUI, org-mode for text-based.

### 16. COMMUNICATION
**Current: Slack + Telegram** ✅
```
✅ INSTALL: slack, telegram-desktop
❌ SKIP: discord, skype, zoom, teams
```
**Reasoning**: Work communication tools.

### 17. MEDIA CONTROLS
**Current: Playerctl** ✅
```
✅ INSTALL: playerctl
❌ SKIP: mpc, cmus-remote
```
**Reasoning**: Universal media control for multiple players.

### 18. BATTERY MANAGEMENT
**Current: cbatticon + Custom Script** ✅
```
✅ INSTALL: cbatticon, alert-battery script
❌ SKIP: batti, battery-status
```
**Reasoning**: Tray icon + custom alerts.

### 19. MOUSE MANAGEMENT
**Current: Unclutter** ✅
```
✅ INSTALL: unclutter
❌ SKIP: unclutter-xfixes, xbanish
```
**Reasoning**: Hides mouse cursor when not in use.

### 20. HOTKEY DAEMONS
**Current: sxhkd** ✅
```
✅ INSTALL: sxhkd
❌ SKIP: xbindkeys, xcape
```
**Reasoning**: Simple and powerful hotkey management.

---

## 🔍 Potential Duplicates Found

### Terminal Multiplexers
- **tmux** (your primary) ✅
- **screen** (legacy) ❌
- **zellij** (modern alternative) ❌

### Shell Enhancements
- **zsh + oh-my-zsh + p10k** (your setup) ✅
- **fish** (alternative shell) ❌
- **bash** (already installed) ❌

### Version Managers
- **pyenv** (Python) ✅
- **rbenv** (Ruby) ✅
- **fnm** (Node.js) ✅
- **asdf** (universal) ❌

### Git Tools
- **lazygit** (TUI) ✅
- **gitui** (alternative TUI) ❌
- **tig** (another TUI) ❌

### Search Tools
- **ripgrep** (fast text search) ✅
- **ag** (silver searcher) ❌
- **ack** (perl-based) ❌

### File Previewers
- **bat** (cat replacement) ✅
- **ccat** (color cat) ❌

### Directory Navigation
- **zoxide** (smarter cd) ✅
- **autojump** (jump to directories) ❌
- **fasd** (command-line productivity) ❌

### Session Management
- **sesh** (your primary session manager) ✅
- **tmuxinator** (predefined tmux sessions) ✅
- **tmux-resurrect** (commented out, not used) ❌

---

## 📋 Installation Priority Matrix

### 🔴 CRITICAL (Must Have)
1. i3-wm + i3ass suite
2. sxhkd + rofi
3. polybar + picom
4. zsh + tmux + neovim
5. ghostty + brave + firefox

### 🟡 HIGH PRIORITY
1. System utilities (fzf, ripgrep, bat, lsd)
2. Development tools (pyenv, rbenv, fnm, lazygit)
3. Productivity (atuin, zoxide, wakatime)
4. Media (spotify, cmus, playerctl)

### 🟢 MEDIUM PRIORITY
1. Desktop apps (slack, telegram, thunar)
2. Utilities (flameshot, ulauncher, blueman)
3. System tools (cbatticon, unclutter)

### 🔵 LOW PRIORITY
1. Additional themes/fonts
2. Backup tools
3. Optional integrations

---

## ⚙️ Configuration Strategy

### Selective Stow Deployment Strategy

#### 🟢 ACTIVE CONFIGS (Install & Stow)
```bash
# Core i3 ecosystem
STOW_PACKAGES_CORE="i3,i3-layout-manager,sxhkd,polybar,picom,rofi"

# Terminal & Shell
STOW_PACKAGES_TERMINAL="ghostty,zsh"

# Development & Git
STOW_PACKAGES_DEV="nvim,tmux,tmuxinator,git,lazygit,gh,gh-dash"

# System Utilities
STOW_PACKAGES_UTILS="fzf,ripgrep,bat,lsd,atuin,zoxide,sesh"

# Desktop & UI (only active ones)
STOW_PACKAGES_DESKTOP="dunst"

# Desktop & UI (available but not auto-stowed)
STOW_SKIP_DESKTOP="nitrogen,gtk-3.0,x11,keyd"
# Desktop package purposes:
# - nitrogen: wallpaper setter (sets desktop background)
# - gtk-3.0: GTK theme settings (dark theme preference)
# - x11: X11 startup configuration (keyboard mapping, daemon startup)
# - keyd: keyboard remapping daemon (caps lock to escape/control)

# Applications
STOW_PACKAGES_APPS="thunar,flameshot,ulauncher,blueman,cbatticon,unclutter,xpad,vimium"

# Development Tools
STOW_PACKAGES_TOOLS="stylua,opencode"

# All active packages
STOW_PACKAGES_ALL="$STOW_PACKAGES_CORE,$STOW_PACKAGES_TERMINAL,$STOW_PACKAGES_DEV,$STOW_PACKAGES_UTILS,$STOW_PACKAGES_DESKTOP,$STOW_PACKAGES_APPS,$STOW_PACKAGES_TOOLS"

# Desktop & UI packages available for manual stowing
STOW_OPTIONAL_DESKTOP="$STOW_SKIP_DESKTOP"
```

#### 🔴 INACTIVE CONFIGS (Keep but Don't Stow)
```bash
# Alternative terminals (keeping for reference)
STOW_SKIP_TERMINALS="alacritty,kitty,wezterm"

# Alternative editors (keeping for reference)
STOW_SKIP_EDITORS="helix,glrnvim,goneovim,neovide,spacemacs"

# Alternative shells (keeping for reference)
STOW_SKIP_SHELLS="nushell"

# Alternative multiplexers (keeping for reference)
STOW_SKIP_MULTIPLEXERS="zellij"

# Alternative file managers (keeping for reference)
STOW_SKIP_FILEMGRS="lf"

# Alternative music players (keeping for reference)
STOW_SKIP_MUSIC="mpd,ncmpcpp"

# Alternative status bars (keeping for reference)
STOW_SKIP_STATUS="i3blocks,i3status"

# Alternative task managers (keeping for reference)
STOW_SKIP_TASKS="taskwarrior"

# Mac-specific tools (keeping for reference)
STOW_SKIP_MAC="hammerspoon"

# Alternative search tools (keeping for reference)
STOW_SKIP_SEARCH="s,serpl"

# Alternative prompt (keeping for reference)
STOW_SKIP_PROMPT="starship"

# Optional tools (keeping for reference)
STOW_SKIP_OPTIONAL="postman,stylus,mcphub"

# All inactive packages
STOW_SKIP_ALL="$STOW_SKIP_TERMINALS,$STOW_SKIP_EDITORS,$STOW_SKIP_SHELLS,$STOW_SKIP_MULTIPLEXERS,$STOW_SKIP_FILEMGRS,$STOW_SKIP_MUSIC,$STOW_SKIP_STATUS,$STOW_SKIP_TASKS,$STOW_SKIP_MAC,$STOW_SKIP_SEARCH,$STOW_SKIP_PROMPT,$STOW_SKIP_OPTIONAL,$STOW_SKIP_DESKTOP"
```

### Conditional Installations
```bash
# Check current usage before installing alternatives
if [[ "$CURRENT_TERMINAL" == "ghostty" ]]; then
    skip_install "wezterm" "kitty" "alacritty"
fi
```

### Modular Configuration
- Each tool gets its own config section
- Easy to enable/disable components
- Clear separation of concerns

### Stow Implementation Strategy
1. **Phase 7**: Add stowing phase after all installations complete
2. **Selective Stowing**: Only stow configs for installed tools
3. **Dependency Checks**: Verify tools are installed before stowing
4. **Backup Safety**: Create backups before stowing
5. **Error Handling**: Skip missing configs gracefully
6. **Post-Stow Validation**: Verify symlinks are created correctly

### Stow Command Structure
```bash
# Template for stowing packages
for package in $(echo $STOW_PACKAGES | tr ',' ' '); do
    if [[ -d "$DOTFILES_DIR/$package" ]]; then
        cd "$DOTFILES_DIR" && stow -v "$package"
    fi
done
```

### Conflict Resolution
- **Existing Files**: Backup and replace with symlinks
- **Permission Issues**: Handle with sudo where necessary
- **Missing Dependencies**: Skip and log warnings
- **Custom Paths**: Handle non-standard config locations

---

## 🚨 Decision Points

### 1. Terminal Choice
- **Keep**: ghostty (your current)
- **Skip**: wezterm, kitty, alacritty
- **Reason**: Extensive ghostty config, active usage

### 2. Browser Strategy
- **Keep**: brave + firefox (both needed)
- **Skip**: vivaldi, chromium
- **Reason**: Different use cases (daily vs dev)

### 3. Music Player Strategy
- **Keep**: spotify + cmus (complementary)
- **Skip**: vlc, rhythmbox
- **Reason**: Streaming + local terminal playback

### 4. File Manager Choice
- **Keep**: thunar (lightweight GTK)
- **Skip**: nautilus, dolphin
- **Reason**: Fits i3 aesthetic, functional

### 5. Password Manager
- **Keep**: bitwarden (configured)
- **Skip**: keepassxc
- **Reason**: Already integrated in workflow

---

## 📝 Implementation Guidelines

### Pre-Installation Checklist
- [ ] Review current tool usage
- [ ] Identify primary vs secondary tools
- [ ] Check for conflicts
- [ ] Plan backup strategy
- [ ] Test in virtual environment first
- [ ] **Verify stow strategy**: Ensure only active configs are stowed

### VM Testing Environment Setup

#### 🖥️ Virtual Machine Configuration
```bash
# Recommended VM Setup
VM_OS="Ubuntu 24.04 LTS Server"
VM_SPECS="4GB RAM, 20GB Disk, 2 CPU cores"
VM_DESKTOP="Xorg + i3-wm (minimal)"
REPOSITORY="https://github.com/lalitmee/dotfiles.git"

# Post-VM Setup Commands
sudo apt update && sudo apt upgrade -y
sudo apt install -y xorg i3-wm lightdm git
sudo systemctl enable lightdm

# Clone dotfiles repository
git clone $REPOSITORY
cd dotfiles
```

#### 🧪 Testing Workflow
```bash
# 1. Clone and prepare
git clone https://github.com/lalitmee/dotfiles.git
cd dotfiles

# 2. Take initial snapshot
# (VM snapshot before testing)

# 3. Run individual phases
./scripts/install/main-installer.zsh
# Select: single-phase → test each phase

# 4. Run full installation
./scripts/install/main-installer.zsh
# Select: full-install

# 5. Validate and test
# Check keybindings, applications, performance
```

#### 📊 Testing Metrics
- **Installation Time**: Track duration of each phase
- **Success Rate**: Percentage of successful installations
- **Error Frequency**: Types and frequency of errors
- **Performance Impact**: CPU, memory, disk usage
- **User Experience**: Keybinding responsiveness, application launch times

### Installation Order
1. Base system (Ubuntu + Xorg + Rust/Go)
2. i3 ecosystem (core functionality)
3. System foundation (shell, terminal, utilities)
4. Development tools (editors, version managers, git)
5. Productivity layer (desktop apps, media, communication)
6. Desktop applications (browsers, additional tools)
7. **Config stowing** (symlink dotfiles to home directory)
8. Final configuration (themes, scripts, validation)

### Testing Strategy

#### 🧪 Comprehensive Testing Plan

##### **Phase 1: Virtual Machine Setup**
- **VM Choice**: Ubuntu 24.04 LTS (matches target environment)
- **VM Specs**: 4GB RAM, 20GB disk, basic graphics
- **Base Setup**: Install Ubuntu Server + Xorg + i3-wm (minimal desktop)
- **Backup**: Take VM snapshot before each major test

##### **Phase 2: Individual Phase Testing**
- **Test Each Phase Independently**:
  - Phase 0: Base Ubuntu (git, curl, rust, go)
  - Phase 1: i3 Core (i3-wm, i3ass, sxhkd)
  - Phase 2: i3 Enhanced (polybar, picom, rofi)
  - Phase 3: System Foundation (zsh, tmux, cargo tools)
  - Phase 4: Development Core (neovim, pyenv, go tools)
  - Phase 5: Productivity Layer (ghostty)
  - Phase 6: Desktop Apps (browsers, communication)
  - Phase 7: Config Stowing (symlinks)
  - Phase 8: Final Setup (fonts, themes)

- **Validation Points**:
  - ✅ Commands execute without errors
  - ✅ Tools are installed and accessible
  - ✅ Configurations are applied correctly
  - ✅ Services start automatically
  - ✅ No conflicts between packages

##### **Phase 3: Integration Testing**
- **Full Installation Run**: Execute complete installation
- **System Boot Test**: Reboot and verify everything works
- **Keybinding Verification**: Test i3, sxhkd, and tmux keybindings
- **Application Launch**: Verify all installed apps launch correctly
- **Performance Check**: Monitor system resources and startup time

##### **Phase 4: Configuration Validation**
- **Symlink Verification**: Check all dotfiles are properly linked
- **Config File Integrity**: Ensure configs are not corrupted
- **Theme Application**: Verify themes and fonts are applied
- **Backup Integrity**: Confirm backups are created and restorable

##### **Phase 5: User Experience Testing**
- **Daily Workflow**: Test common development tasks
- **Terminal Usage**: Verify ghostty, tmux, zsh integration
- **i3 Navigation**: Test window management and layouts
- **Application Integration**: Check browser, editor, git workflow

##### **Phase 6: Error Handling & Recovery**
- **Failure Scenarios**: Test partial failures and recovery
- **Dependency Issues**: Verify handling of missing dependencies
- **Network Issues**: Test offline/package download failures
- **Rollback Procedure**: Validate backup restoration

##### **Phase 7: Performance & Optimization**
- **Startup Time**: Measure system boot and application startup
- **Memory Usage**: Monitor resource consumption
- **Disk Usage**: Check storage impact
- **Optimization**: Identify and fix performance bottlenecks

#### 📋 Testing Checklist

##### **Pre-Test Setup**
- [ ] Create Ubuntu 24.04 VM
- [ ] Install minimal desktop environment
- [ ] Clone dotfiles repository
- [ ] Take initial VM snapshot

##### **Phase-by-Phase Testing**
- [ ] Phase 0: Base system installation
- [ ] Phase 1: i3 core functionality
- [ ] Phase 2: Enhanced i3 features
- [ ] Phase 3: System foundation tools
- [ ] Phase 4: Development environment
- [ ] Phase 5: Terminal and productivity
- [ ] Phase 6: Desktop applications
- [ ] Phase 7: Configuration stowing
- [ ] Phase 8: Final setup and themes

##### **Integration Testing**
- [ ] Full installation run
- [ ] System reboot verification
- [ ] Keybinding functionality
- [ ] Application integration
- [ ] Performance metrics

##### **Validation Points**
- [ ] All tools installed correctly
- [ ] Configurations applied properly
- [ ] Symlinks created successfully
- [ ] Backups created and restorable
- [ ] No system conflicts
- [ ] Performance acceptable

##### **Documentation Updates**
- [ ] Update installation guide
- [ ] Document known issues
- [ ] Create troubleshooting guide
- [ ] Update version compatibility

#### 🚨 Risk Mitigation

##### **Backup Strategy**
- VM snapshots before each test phase
- Configuration backups during stowing
- Full system backup before complete installation
- Easy rollback procedures

##### **Failure Recovery**
- Individual phase rollback capability
- Configuration restoration from backups
- Alternative installation methods
- Manual intervention procedures

##### **Safety Measures**
- Test in isolated VM environment
- No impact on production system
- Gradual testing approach
- Comprehensive logging

#### 📊 Success Criteria

##### **Functional Requirements**
- [ ] All specified tools install successfully
- [ ] Configurations apply correctly
- [ ] System boots and runs stably
- [ ] Keybindings work as expected
- [ ] Applications integrate properly

##### **Performance Requirements**
- [ ] System startup < 30 seconds
- [ ] Application launch < 5 seconds
- [ ] Memory usage < 2GB idle
- [ ] No system instability

##### **User Experience**
- [ ] Intuitive keybindings
- [ ] Consistent theme application
- [ ] Reliable application launching
- [ ] Smooth window management

#### 📝 Testing Documentation

##### **Test Logs**
- Command execution results
- Error messages and resolutions
- Performance measurements
- Configuration validation results

##### **Issue Tracking**
- Known bugs and workarounds
- Compatibility issues
- Performance bottlenecks
- User experience improvements

##### **Version Compatibility**
- Ubuntu version compatibility
- Package version conflicts
- Dependency requirements
- Hardware requirements

---

## 📊 Current Tool Inventory

### Installed & Configured
- [x] i3-wm + i3ass suite
- [x] sxhkd + rofi + ulauncher
- [x] polybar + picom
- [x] zsh + tmux + neovim
- [x] ghostty + brave + firefox
- [x] Development tools (pyenv, rbenv, fnm, lazygit)
- [x] Productivity tools (atuin, zoxide, wakatime)
- [x] Media tools (spotify, cmus, playerctl)
- [x] System utilities (fzf, ripgrep, bat, lsd)
- [x] Desktop tools (dunst - active) | (nitrogen, gtk-3.0, x11, keyd - available for manual stowing)

### To Be Installed
- [ ] Desktop applications (slack, telegram, thunar)
- [ ] Additional utilities (flameshot, ulauncher, blueman)
- [ ] Config stowing (symlink dotfiles - dunst only)
- [ ] Final configuration and themes

### Optional Desktop Configs (Manual Stowing)
If you want to use additional desktop configurations later:
```bash
cd ~/dotfiles
stow nitrogen    # wallpaper setter
stow gtk-3.0     # GTK dark theme settings
stow x11         # X11 startup configuration
stow keyd        # keyboard remapping (caps→esc/ctrl)
```

---

## 🔧 Technical Notes

### Dependencies to Track
- Xorg and X11 libraries
- GTK and Qt libraries
- Audio systems (PulseAudio, ALSA)
- Font rendering (freetype, fontconfig)
- Network management (NetworkManager)

### Configuration Files to Preserve
- All dotfiles in current structure
- Custom scripts in bin/
- Theme configurations
- Keybinding setups

### Backup Strategy
- Full system backup before changes
- Configuration file backups
- Test environment for validation

---

*Last Updated: $(date)*
*Reviewed By: Lalit Kumar*