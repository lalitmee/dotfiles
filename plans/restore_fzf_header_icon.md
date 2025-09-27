# Feature Implementation Plan: Restore FZF Header Icon

## 📋 Todo Checklist
- [ ] Analyze the `tool.sh` script to find the source of the regression.
- [ ] Re-introduce an `ICON` variable for each tool definition.
- [ ] Update the `FZF_HEADER` to include the `ICON` variable.
- [ ] Final Review and Testing.

## 🔍 Analysis & Investigation

### Root Cause of Regression

During the last refactoring, the `FZF_HEADER` variable was simplified to use only the `$TOOL` variable for coloring purposes:

```bash
FZF_HEADER="Choose layout for ${COLOR_YELLOW}${TOOL}${RESET_COLOR}:"
```

Previously, the header was constructed from the `$PANE_TITLE` variable, which contained both the icon and the tool name (e.g., `"🤖 Gemini"`). My simplification inadvertently dropped the icon from the header string.

The fix is to make the icon an explicit, separate variable and then construct the header from both the icon and the colored tool name.

### Files Inspected
- `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`

## 📝 Implementation Plan

### Prerequisites
- The `tool.sh` script from the previous plan is the baseline for this change.

### Step-by-Step Implementation

1.  **Step 1**: Update Tool Definitions to Isolate Icons
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: In the main `case "$TOOL"` block, we will explicitly define an `ICON` variable for each tool and use it in the `PANE_TITLE`. This makes the icon accessible for use elsewhere and makes the code more modular.

    -   **For `gemini`**: 
        -   Change from: `PANE_TITLE="🤖 Gemini"`
        -   Change to: `ICON="🤖"; PANE_TITLE="$ICON Gemini"`

    -   **For `opencode`**:
        -   Change from: `PANE_TITLE="🧑‍💻 OpenCode"`
        -   Change to: `ICON="🧑‍💻"; PANE_TITLE="$ICON OpenCode"`

    -   **For `claude`**:
        -   Change from: `PANE_TITLE="✨ Claude"`
        -   Change to: `ICON="✨"; PANE_TITLE="$ICON Claude"`

    -   **For `codex`**:
        -   Change from: `PANE_TITLE="🚀 Codex"`
        -   Change to: `ICON="🚀"; PANE_TITLE="$ICON Codex"`

    -   **For `qwen`**:
        -   Change from: `PANE_TITLE="🧠 Qwen"`
        -   Change to: `ICON="🧠"; PANE_TITLE="$ICON Qwen"`

2.  **Step 2**: Reconstruct FZF Header to Include Icon
    -   **Files to modify**: `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/ai/tool.sh`
    -   **Changes needed**: Modify the `FZF_HEADER` definition to prepend the new `$ICON` variable before the colored tool name.

    ```bash
    # Find this line:
    FZF_HEADER="Choose layout for ${COLOR_YELLOW}${TOOL}${RESET_COLOR}:"

    # And replace it with this:
    FZF_HEADER="Choose layout for $ICON ${COLOR_YELLOW}${TOOL}${RESET_COLOR}:"
    ```

### Testing Strategy

1.  Press any of the AI tool keybindings (e.g., for `gemini`).
2.  **Verification**: Observe the `fzf` menu that appears. The header should now display the correct icon next to the yellow tool name (e.g., `🤖 gemini:`).
3.  **Regression Test**: Select any layout option (`popup`, `split`, `window`) and confirm that the tool still launches correctly. The window title for the `window` option should also still correctly display the icon and name.

## 🎯 Success Criteria

-   The icon for each respective AI tool is restored and visible in the `fzf` header.
-   The tool name in the header remains yellow.
-   The core launcher functionality is not impacted.
