# ScreenKey Plugin

A Neovim plugin that displays a floating window showing the keys you're pressing in real-time. Perfect for creating tutorials, screencasts, or learning new keybindings.

## Features

- 🎹 **Real-time key display** - Shows keys as you type them
- 🪟 **Floating window** - Non-intrusive overlay that doesn't interfere with editing
- 🎨 **Customizable appearance** - Configure position, size, and styling
- ⌨️ **Smart key formatting** - Displays readable names for special keys (C-a, arrows, etc.)
- ⏰ **Auto-clear** - Keys disappear after a configurable timeout
- 📱 **Responsive** - Handles window resizing gracefully
- 🔄 **Horizontal scrolling** - Keys scroll horizontally as you type
- 🎯 **All key types** - Shows space, enter, escape, and all special keys

## Installation

The plugin is already installed in your Neovim configuration at:
```
~/.config/nvim/after/plugin/screenkey/
├── init.lua          # Main plugin file
└── README.md         # This documentation
```

## Usage

### Commands

- `:ScreenKeyToggle` - Toggle the key display on/off
- `:ScreenKeyEnable` - Enable the key display
- `:ScreenKeyDisable` - Disable the key display
- `:ScreenKeyClear` - Clear the current key display

### Key Mappings

- `<leader>sk` - Toggle ScreenKey (default: `\sk`)
- `<leader>sc` - Clear keys (default: `\sc`)

### Configuration

You can customize the plugin by calling the setup function in your `init.lua`:

```lua
require('screenkey').setup({
  width = 60,                    -- Window width
  height = 1,                    -- Window height (single line)
  position = 'topright',         -- Position: topright, topleft, bottomright, bottomleft, topcenter, bottomcenter
  offset_x = 2,                  -- X offset from edge
  offset_y = 2,                  -- Y offset from edge
  border = 'none',               -- Border style: none, single, double, rounded, solid, shadow
  title = '',                    -- Window title (empty for clean look)
  max_keys = 20,                 -- Maximum keys to display
  timeout = 3000,                -- Auto-clear timeout (ms)
  clear_on_mode_change = false,  -- Clear keys when switching modes
})
```

## Example Usage

1. **Start a tutorial session:**
   ```vim
   :ScreenKeyToggle
   ```

2. **Show your audience the keys as you type:**
   - Type `gg` to go to top of file
   - Type `/search` to search
   - Type `:%s/old/new/g` for find & replace

3. **Clear the display when needed:**
   ```vim
   :ScreenKeyClear
   ```

4. **End the tutorial:**
   ```vim
   :ScreenKeyToggle
   ```

## Key Formatting

The plugin automatically formats keys for better readability:

- ` ` → `SPC` (Space key)
- `<CR>` → `RET` (Enter/Return)
- `<Tab>` → `TAB` (Tab key)
- `<Esc>` → `ESC` (Escape key)
- `<BS>` → `BS` (Backspace)
- `<Del>` → `DEL` (Delete)
- `Ctrl+A` → `Ctrl-A` (Control combinations)
- `Alt+X` → `Alt-X` (Alt combinations)
- `<Left>` → `←` (Arrow keys)
- `<F1>` → `F1` (Function keys)
- Regular letters and numbers display as-is

## Supported Positions

- `topleft` - Top left corner
- `topright` - Top right corner (default)
- `topcenter` - Top center
- `bottomleft` - Bottom left corner
- `bottomright` - Bottom right corner
- `bottomcenter` - Bottom center

## Tips for Tutorials

1. **Position the window** where it won't obstruct your main content
2. **Use the timeout** to automatically clear keys between demonstrations
3. **Clear manually** between different sections of your tutorial
4. **Configure the size** based on how many keys you want to show at once

## Requirements

- Neovim 0.10+ (uses `vim.on_key` for key capture)
- The plugin loads automatically when Neovim starts

## Troubleshooting

If keys aren't displaying:
1. Make sure ScreenKey is enabled: `:ScreenKeyToggle`
2. Check that you're using Neovim 0.10+
3. Try reloading the plugin: `:source ~/.config/nvim/after/plugin/screenkey/init.lua`

## Demo

Here's what it looks like in action:

```
gg / search RET
```

With special keys and combinations:
```
Ctrl-W Ctrl-W ← → SPC RET
```

Complex key sequences:
```
gg V Shift-G : s / old / new / RET
```

The keys scroll horizontally and show your recent key presses in a clean, single line format.

Enjoy creating amazing tutorials with ScreenKey! 🎹