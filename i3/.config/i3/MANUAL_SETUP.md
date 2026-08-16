# 🛠️ Manual System Configurations & Overrides

This document tracks system-level settings, default application associations (XDG/MIME), GTK preferences, and environment configurations that cannot be completely automated through dotfile symlinks (`stow`) or installer scripts.

---

## 📂 Default Applications & MIME Handlers

XDG MIME associations control which application opens specific file types, URL schemes, and directories. These settings are stored in `~/.config/mimeapps.list`.

### 1. Default File Manager (Thunar)

To set **Thunar** as the default directory and file handler across the desktop:

```bash
# Set directory and file scheme handlers to Thunar
xdg-mime default thunar.desktop inode/directory
xdg-mime default thunar.desktop x-scheme-handler/file
xdg-mime default thunar.desktop x-scheme-handler/trash
```

Verify the active default file manager:

```bash
xdg-mime query default inode/directory
```

### 2. General Default Applications Reference

| Category | Recommended Application | Desktop Entry | Command to Set Default |
| :--- | :--- | :--- | :--- |
| **File Manager** | Thunar | `thunar.desktop` | `xdg-mime default thunar.desktop inode/directory` |
| **Web Browser** | Vivaldi / Brave / Firefox | `vivaldi-stable.desktop` | `xdg-mime default vivaldi-stable.desktop x-scheme-handler/https` |
| **PDF Viewer** | Evince | `org.gnome.Evince.desktop` | `xdg-mime default org.gnome.Evince.desktop application/pdf` |
| **Image Viewer** | Eye of GNOME (eog) / feh | `org.gnome.eog.desktop` | `xdg-mime default org.gnome.eog.desktop image/png image/jpeg` |
| **Media Player** | mpv / VLC | `mpv.desktop` | `xdg-mime default mpv.desktop video/mp4 video/mkv` |

---

## 🎨 GTK & Desktop Theming

Since i3 is a standalone window manager without a full desktop environment settings daemon, GTK settings are configured via `~/.config/gtk-3.0/settings.ini` or GUI tools.

### Useful Tools for Theme Management

- **LXAppearance**: GUI tool for switching GTK themes, icon packs, and cursor themes:
  ```bash
  sudo apt install lxappearance
  ```
- **Xfce4 Appearance Settings** (optional for XFCE apps):
  ```bash
  xfce4-appearance-settings
  ```

---

## 🖥️ Multi-Monitor & Display Management

Display layouts are managed via X11 / `xrandr`.

### Saving and Restoring Display Layouts

- **ARandR** (GUI for visual monitor layout adjustments):
  ```bash
  sudo apt install arandr
  ```
- **AutoRandR** (automatically applies display profiles on monitor connect/disconnect):
  ```bash
  # Save current connected monitor configuration as profile 'home' or 'work'
  autorandr --save home
  ```

---

## 🔍 System Inspection & Debugging Tools

Quick commands to inspect active windows, MIME associations, and desktop environment attributes:

### 1. Identify Window Properties (Class, Name, Role)

Use `xprop` to click any window and reveal its `WM_CLASS` and window hints (useful for i3 rules and scratchpads):

```bash
xprop | grep -E 'WM_CLASS|WM_NAME|_NET_WM_NAME'
```

### 2. Inspect MIME Types of Files

To find the exact MIME type of a file before binding it:

```bash
xdg-mime query filetype path/to/file.ext
```

### 3. Check Protocol Handlers

```bash
xdg-mime query default x-scheme-handler/http
xdg-mime query default x-scheme-handler/https
```
