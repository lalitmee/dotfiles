# Tmux Help System

A modular help system for tmux that displays keybindings in beautiful gum tables.

## Features

- **Modular Design**: Each help table is in its own file
- **Beautiful UI**: Uses gum tables with tmux theme colors
- **Easy Maintenance**: Simple text files for help content
- **Popup Interface**: Non-blocking help display

## Usage

### From Command Line
```bash
# Show help for a specific table
./help.sh ai-tools
./help.sh second-brain
./help.sh layout-mode
./help.sh session-mgmt
./help.sh global

# List all available tables
./help.sh --list

# Show usage
./help.sh --help
```

### From Tmux
- `C-a C-i ?` → AI tools help
- `C-a b ?` → Second brain help  
- `C-b ?` → Layout mode help
- `C-a S ?` → Session management help
- `C-a H` → Global help

## File Structure

```
help/
├── help.sh              # Main help script
├── README.md           # This file
├── tables/
│   ├── ai-tools.txt    # AI tools keybindings
│   ├── second-brain.txt # Second brain keybindings
│   ├── layout-mode.txt # Layout mode keybindings
│   ├── session-mgmt.txt # Session management keybindings
│   └── global.txt      # Global keybindings
└── templates/          # Future templates
```

## Adding New Help Tables

1. Create a new `.txt` file in the `tables/` directory
2. Format: Tab-separated values with header row
3. Update tmux config to bind `?` in that table
4. Add documentation to this README

### Example Table Format

```
Key	Description
g	Gemini AI assistant
o	OpenCode AI assistant
q	Quit table
```

## Dependencies

- **gum**: For beautiful table display
  - macOS: `brew install gum`
  - Linux: Check your package manager

## Maintenance Notes

When making changes to keybindings:
1. Update the corresponding `.txt` file in `tables/`
2. Test the help display: `./help.sh <table-name>`
3. Ensure table formatting is correct (tab-separated)

## Customization

Colors are defined in `help.sh` and match the tmux cobalt2 theme:
- Header: Yellow text on dark blue background
- Body: White text on dark background  
- Border: Blue rounded border

Modify the color variables in `help.sh` to match your theme.
