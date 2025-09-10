# 🚨 Installation Troubleshooting Guide

This guide covers common issues and their solutions for the dotfiles installation system.

## 📋 Quick Diagnosis

### Check System Requirements
```bash
# Check Ubuntu version
lsb_release -a

# Check available disk space
df -h

# Check internet connectivity
ping -c 3 google.com

# Check sudo access
sudo -v
```

### Validate Installation State
```bash
# Check if key tools are installed
which git cargo go nvim zsh tmux

# Check PATH
echo $PATH

# Check if gum is available
which gum || echo "gum not found - install from Phase 3"
```

## 🔧 Common Issues & Solutions

### Issue 1: "Command not found" Errors

**Symptoms:**
- `gum: command not found`
- `cargo: command not found`
- `go: command not found`

**Solutions:**
```bash
# Fix PATH issues
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$PATH"

# Re-run Phase 0 for base tools
./scripts/install/phases/00-base-ubuntu.zsh

# Re-run Phase 3 for development tools
./scripts/install/phases/03-system-foundation.zsh
```

### Issue 2: Permission Denied Errors

**Symptoms:**
- `sudo: command not found`
- Permission denied during installation
- Cannot create directories

**Solutions:**
```bash
# Check if you're running as root (don't!)
whoami

# Ensure you have sudo access
sudo -v

# Fix ownership of home directory
sudo chown -R $USER:$USER $HOME
```

### Issue 3: Network/Download Failures

**Symptoms:**
- `curl: (6) Could not resolve host`
- `git clone` fails
- Package downloads fail

**Solutions:**
```bash
# Check network connectivity
ping -c 3 8.8.8.8

# Update DNS settings
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Try alternative mirrors
sudo sed -i 's/us.archive.ubuntu.com/mirror.ubuntu.com/' /etc/apt/sources.list
sudo apt update
```

### Issue 4: Build Failures (Neovim, Polybar, i3ass)

**Symptoms:**
- `make: *** [target] Error 1`
- Compilation errors
- Missing dependencies

**Solutions:**
```bash
# Install build dependencies
sudo apt install -y build-essential cmake ninja-build

# Clean previous builds
cd ~/Projects/Personal/Github/neovim
make clean && make distclean
rm -rf build/

# Check available memory (compilation needs ~2GB RAM)
free -h

# Re-run specific phase
./scripts/install/phases/04-development-core.zsh
```

### Issue 5: Stow Conflicts

**Symptoms:**
- `stow: ERROR: existing target`
- Symlinks not created
- Configuration files not applied

**Solutions:**
```bash
# Backup existing configs
mkdir -p ~/.dotfiles-backup-$(date +%Y%m%d)
mv ~/.zshrc ~/.dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null

# Remove conflicting files
rm -rf ~/.config/i3 ~/.config/polybar ~/.zshrc

# Re-run stowing
./scripts/install/phases/07-config-stow.zsh

# Manual stowing
cd ~/dotfiles && stow zsh && stow i3
```

### Issue 6: i3 Won't Start

**Symptoms:**
- Login screen loops
- Black screen after login
- i3 not appearing in session menu

**Solutions:**
```bash
# Check i3 installation
which i3
dpkg -l | grep i3

# Verify display manager configuration
sudo dpkg-reconfigure lightdm

# Check Xorg configuration
ls /etc/X11/xorg.conf.d/

# Start i3 manually for testing
xinit /usr/bin/i3
```

### Issue 7: Font Issues

**Symptoms:**
- Icons not displaying
- Text rendering problems
- Polybar shows boxes instead of icons

**Solutions:**
```bash
# Update font cache
fc-cache -fv

# Check font installation
ls ~/.local/share/fonts/
fc-list | grep "Fira\|JetBrains"

# Re-run font installation
./scripts/install/phases/08-final-setup.zsh

# Verify fontconfig
fc-match "FiraCode Nerd Font"
```

### Issue 8: Ruby/Node.js Tool Issues

**Symptoms:**
- `rbenv: command not found`
- `fnm: command not found`
- Version managers not working

**Solutions:**
```bash
# Source version manager scripts
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc

echo 'export PATH="$HOME/.fnm:$PATH"' >> ~/.zshrc
echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc

# Restart shell
exec zsh

# Re-run Phase 4
./scripts/install/phases/04-development-core.zsh
```

### Issue 9: Ghostty Installation Fails

**Symptoms:**
- `404 Not Found` for ghostty download
- Architecture detection fails

**Solutions:**
```bash
# Check system architecture
uname -m

# Manual download with correct URL
# Visit: https://github.com/mkasberg/ghostty-ubuntu/releases
# Download the correct .deb for your Ubuntu version

# Install manually
sudo dpkg -i ghostty_*.deb
sudo apt install -f
```

### Issue 10: Polybar Won't Start

**Symptoms:**
- Polybar not appearing
- Errors in polybar logs

**Solutions:**
```bash
# Check dependencies
ldd /usr/local/bin/polybar

# Test polybar manually
polybar --version

# Check configuration
ls ~/.config/polybar/

# Start polybar manually for testing
polybar main &
```

## 🛠️ Recovery Procedures

### Complete System Reset
```bash
# Remove all installed packages (CAUTION!)
sudo apt remove --purge i3* polybar picom rofi neovim zsh tmux
sudo apt autoremove --purge

# Clean up dotfiles
rm -rf ~/.config/i3 ~/.config/polybar ~/.zshrc ~/.tmux.conf

# Start fresh
./scripts/install/main-installer.zsh
```

### Partial Recovery
```bash
# Reset specific component
rm -rf ~/.config/i3
cd ~/dotfiles && stow i3

# Reinstall specific package
sudo apt reinstall i3-wm

# Reset shell configuration
rm ~/.zshrc
cd ~/dotfiles && stow zsh
```

### Backup and Restore
```bash
# Create backup before changes
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz ~/.config ~/.local ~/.zshrc

# Restore from backup
tar -xzf ~/dotfiles-backup-*.tar.gz -C ~/
```

## 📊 Diagnostic Commands

### System Information
```bash
# Hardware info
lscpu
free -h
df -h

# Software versions
lsb_release -a
apt list --installed | grep -E "(i3|polybar|neovim|zsh|tmux)"

# Environment
env | grep -E "(PATH|HOME|USER)"
```

### Log Analysis
```bash
# System logs
journalctl -xe | tail -50

# Xorg logs
cat /var/log/Xorg.0.log | tail -50

# Display manager logs
cat /var/log/lightdm/lightdm.log | tail -50
```

### Network Diagnostics
```bash
# DNS resolution
nslookup github.com

# Package repository status
curl -I https://deb.debian.org/

# Git connectivity
git ls-remote https://github.com/neovim/neovim.git
```

## 🚨 Emergency Contacts

If all else fails:

1. **Check the GitHub repository** for updates
2. **Review SYSTEM_SETUP_CONTEXT.md** for configuration conflicts
3. **Test in a virtual machine** first
4. **Join the community** for help with specific issues

## 📝 Prevention Tips

- **Always backup** before major changes
- **Test in VM** for risky operations
- **Check disk space** before installations
- **Verify network** before downloads
- **Read error messages** carefully
- **Use the main installer** instead of individual phases when possible

---

*Last updated: $(date)*
*For the latest troubleshooting information, check the repository.*